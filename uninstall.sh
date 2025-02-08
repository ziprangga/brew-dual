#!/usr/bin/env bash

# ====== Global Variables ======
INSTALL_DIR="$HOME/.config/brew-dual"
BIN_DIR="$INSTALL_DIR/bin"

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

# ====== Confirm Uninstall ======
confirm_uninstall() {
    echo -e "\033[0;33m⚠️  WARNING: This will permanently remove brew-dual.\033[0m"
    read -rp "Are you sure you want to continue? (y/N): " confirm
    case "$confirm" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) log "INFO" "Uninstall canceled."; exit 0 ;;
    esac
}

# ====== Remove PATH Entry ======
remove_path() {
    log "INFO" "Removing $BIN_DIR from PATH..."

    local shell_profile=""
    case "$SHELL" in
        */zsh)  shell_profile="$HOME/.zshrc" ;;
        */bash) shell_profile="$HOME/.bashrc" ;;
        */fish) shell_profile="$HOME/.config/fish/config.fish" ;;
        *)
            log "WARN" "Unknown shell. Please manually remove '$BIN_DIR' from your PATH."
            return
            ;;
    esac

    if [[ ! -f "$shell_profile" ]]; then
        log "WARN" "Shell profile $shell_profile not found. Skipping PATH cleanup."
        return
    fi

    if grep -q "$BIN_DIR" "$shell_profile"; then
        # Backup the original profile before modifying
        cp "$shell_profile" "$shell_profile.bak"
        sed -i '' "/export PATH=.*$BIN_DIR/d" "$shell_profile"
        log "INFO" "Removed PATH entry from $shell_profile. Backup saved as $shell_profile.bak"
    else
        log "INFO" "No PATH entry found in $shell_profile."
    fi
}

# ====== Uninstall Plugin ======
uninstall_plugin() {
    if [[ -d "$INSTALL_DIR" ]]; then
        log "INFO" "Removing brew-dual installation..."
        rm -rf "$INSTALL_DIR"
        log "INFO" "✅ Uninstallation complete!"
    else
        log "WARN" "brew-dual is not installed."
    fi
}

# ====== Main Uninstall Process ======
main() {
    confirm_uninstall
    remove_path
    uninstall_plugin
    log "INFO" "Restart your shell or run 'source ~/.zshrc' or 'source ~/.bashrc' to apply changes."
}

# ====== Execute Uninstall ======
main
