#!/usr/bin/env bash

# ====== Global Variables ======
GITHUB_REPO="https://github.com/ziprangga/brew-dual.git"
INSTALL_DIR="$HOME/.config/brew-dual"
CORE_DIR="$INSTALL_DIR/core"
BIN_DIR="$CORE_DIR/bin"
LIBEXEC_DIR="$CORE_DIR/libexec"

# ====== Logging Function ======
log() {
    local level="$1"
    local message="$2"
    local color_reset="\033[0m"
    local color_info="\033[0;32m"
    local color_warn="\033[0;33m"
    local color_error="\033[0;31m"

    case "$level" in
        INFO)  echo -e "${color_info}[INFO] $message${color_reset}" ;;
        WARN)  echo -e "${color_warn}[WARN] $message${color_reset}" ;;
        ERROR) echo -e "${color_error}[ERROR] $message${color_reset}" ;;
        *)     echo -e "[LOG] $message" ;;
    esac
}

# ====== Check Dependencies ======
check_dependencies() {
    if ! command -v git &>/dev/null; then
        log "ERROR" "Git is not installed. Please install Git and try again."
        exit 1
    fi
}

# ====== Clone or Update Repository ======
install_plugin() {
    if [[ -d "$INSTALL_DIR/.git" ]]; then
        log "INFO" "Updating existing brew-dual installation..."
        cd "$INSTALL_DIR" || { log "ERROR" "Failed to change directory to $INSTALL_DIR"; exit 1; }
        
        # Stash local changes before updating
        git stash --include-untracked
        
        # Pull latest changes safely
        git pull --rebase origin main || {
            log "ERROR" "Failed to update brew-dual. Please check your internet connection."
            exit 1
        }
    else
        log "INFO" "Cloning brew-dual from GitHub..."
        git clone --depth=1 "$GITHUB_REPO" "$INSTALL_DIR" || {
            log "ERROR" "Failed to clone brew-dual. Please check your internet connection."
            exit 1
        }
    fi

    # Ensure bin and libexec directories exist
    if [[ ! -d "$BIN_DIR" || ! -d "$LIBEXEC_DIR" ]]; then
        log "ERROR" "brew-dual repository structure is invalid (missing core/bin or core/libexec)"
        exit 1
    fi

    # Ensure the scripts are executable if they exist
    find "$BIN_DIR" -type f -exec chmod +x {} \;

    # Make all libexec scripts executable
    find "$LIBEXEC_DIR" -type f -exec chmod +x {} \;
}

# ====== Ensure ~/brew-dual/bin is in PATH ======
ensure_path() {
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        log "INFO" "Adding $BIN_DIR to PATH..."

        # Detect shell and update the correct profile file
        local shell_profile
        case "$SHELL" in
            */zsh)  shell_profile="$HOME/.zshrc" ;;
            */bash) shell_profile="$HOME/.bashrc" ;;
            *)
                log "WARN" "Unknown shell. Please manually add '$BIN_DIR' to your PATH."
                return
                ;;
        esac

        # Prevent duplicate PATH entries
        if ! grep -qF "$BIN_DIR" "$shell_profile"; then
            echo 'export PATH="'"$BIN_DIR"':$PATH"' >> "$shell_profile"
            log "INFO" "Run 'source $shell_profile' to apply changes."
        else
            log "INFO" "PATH already configured in $shell_profile"
            log "WARN" "Please ensure that '$BIN_DIR' is already in your PATH. If not, add it manually."
        fi

        export PATH="$BIN_DIR:$PATH"
    fi
}

# ====== Main Install Process ======
main() {
    check_dependencies
    install_plugin
    ensure_path
    log "INFO" "✅ Installation complete! Run 'brew-dual help' to get started or run 'brew dual check-homebrew' to ensure that Homebrew is installed for both ARM and x86 architectures"
}

# ====== Execute Install ======
main
