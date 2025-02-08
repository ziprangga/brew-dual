#!/usr/bin/env bash

# ====== Global Variables ======
GITHUB_REPO="https://github.com/ziprangga/brew-dual.git"
INSTALL_DIR="$HOME/.config/brew-dual"
BIN_DIR="$INSTALL_DIR/bin"
LIBEXEC_DIR="$INSTALL_DIR/libexec"

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
    mkdir -p "$BIN_DIR" "$LIBEXEC_DIR"

    # Ensure the scripts are executable if they exist
    [[ -f "$BIN_DIR/brew-dual" ]] && chmod +x "$BIN_DIR/brew-dual"
    [[ -f "$BIN_DIR/brew-arm" ]] && chmod +x "$BIN_DIR/brew-arm"
    [[ -f "$BIN_DIR/brew-x86" ]] && chmod +x "$BIN_DIR/brew-x86"

    # Make all libexec scripts executable
    [[ -d "$LIBEXEC_DIR" ]] && find "$LIBEXEC_DIR" -type f -exec chmod +x {} \;
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
        if ! grep -q 'export PATH="'"$BIN_DIR"':$PATH"' "$shell_profile"; then
            echo 'export PATH="'"$BIN_DIR"':$PATH"' >> "$shell_profile"
            log "INFO" "Run 'source $shell_profile' to apply changes."
        else
            log "INFO" "PATH already configured in $shell_profile"
        fi

        export PATH="$BIN_DIR:$PATH"
    fi
}

# ====== Main Install Process ======
main() {
    check_dependencies
    install_plugin
    ensure_path
    log "INFO" "✅ Installation complete! Run 'brew-dual help' to get started."
}

# ====== Execute Install ======
main
