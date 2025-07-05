
#!/bin/bash

APP_DIR_ROOT="/opt" LAUNCHER_DIR="$HOME/.local/share/applications" DESKTOP_DIR="$HOME/Desktop" LOG_FILE="$HOME/.appimage_manager.log" INSTALL_DIR="$HOME/.local/bin" SCRIPT_NAME="appimage_manager.sh" REPO_URL="https://github.com/yourusername/appimage-manager"

install_dependencies() { if ! command -v zenity &>/dev/null; then echo "Zenity is not installed. Installing it now..." sudo apt update && sudo apt install -y zenity || { echo "Failed to install Zenity. Please install it manually." >&2 exit 1 } fi }

check_zenity() { if ! command -v zenity &>/dev/null; then echo "Zenity is required. Install it with: sudo apt install zenity" exit 1 fi }

log() { echo "[$(date)] $1" >> "$LOG_FILE" }

install_appimage() { APPIMAGE_FILE=$(zenity --file-selection --title="Select AppImage File" --filename="$HOME/") [[ -z "$APPIMAGE_FILE" ]] && return

APP_NAME=$(zenity --entry --title="App Name" --text="Enter application name (no spaces):")
[[ -z "$APP_NAME" ]] && return

ICON_FILE=$(zenity --file-selection --title="Select Optional Icon" --file-filter="Images | *.png *.svg" --filename="$APPIMAGE_FILE" 2>/dev/null)

APP_DIR="$APP_DIR_ROOT/$APP_NAME"
sudo mkdir -p "$APP_DIR"
sudo cp "$APPIMAGE_FILE" "$APP_DIR/"
sudo chmod +x "$APP_DIR/$(basename "$APPIMAGE_FILE")"

if [[ -f "$ICON_FILE" ]]; then
    sudo cp "$ICON_FILE" "$APP_DIR/icon.png"
    ICON="$APP_DIR/icon.png"
else
    ICON="$APP_DIR/$(basename "$APPIMAGE_FILE")"
fi

cat > "$LAUNCHER_DIR/$APP_NAME.desktop" <<EOF

[Desktop Entry] Name=$APP_NAME Exec=$APP_DIR/$(basename "$APPIMAGE_FILE") Icon=$ICON Type=Application Categories=Utility; Terminal=false EOF

chmod +x "$LAUNCHER_DIR/$APP_NAME.desktop"
cp "$LAUNCHER_DIR/$APP_NAME.desktop" "$DESKTOP_DIR/$APP_NAME.desktop"
chmod +x "$DESKTOP_DIR/$APP_NAME.desktop"

log "Installed $APP_NAME"
zenity --info --text="Installed $APP_NAME to start menu and desktop."

}

uninstall_appimage() { APP_LIST=$(ls "$APP_DIR_ROOT" 2>/dev/null) [[ -z "$APP_LIST" ]] && zenity --info --text="No AppImages found in /opt" && return

APP_NAME=$(echo "$APP_LIST" | zenity --list --title="Uninstall AppImage" --column="Installed Apps" --height=400)
[[ -z "$APP_NAME" ]] && return

zenity --question --text="Uninstall $APP_NAME?" || return

sudo rm -rf "$APP_DIR_ROOT/$APP_NAME"
rm -f "$LAUNCHER_DIR/$APP_NAME.desktop"
rm -f "$DESKTOP_DIR/$APP_NAME.desktop"

log "Uninstalled $APP_NAME"
zenity --info --text="$APP_NAME has been uninstalled."

}

list_appimages() { APPS=$(ls "$APP_DIR_ROOT" 2>/dev/null) [[ -z "$APPS" ]] && zenity --info --text="No AppImages installed." && return

zenity --list --title="Installed AppImages" --column="Applications" $APPS --height=400

}

main_menu() { while true; do ACTION=$(zenity --list --title="AppImage Manager" 
--column="Action" --height=300 
"Install AppImage" 
"Uninstall AppImage" 
"List Installed AppImages" 
"View Install Log" 
"Exit")

case "$ACTION" in
        "Install AppImage") install_appimage ;;
        "Uninstall AppImage") uninstall_appimage ;;
        "List Installed AppImages") list_appimages ;;
        "View Install Log") zenity --text-info --title="Install Log" --filename="$LOG_FILE" --width=600 --height=400 ;;
        "Exit" | "") exit 0 ;;
    esac
done

}

create_manager_shortcut() { mkdir -p "$INSTALL_DIR" cp "$0" "$INSTALL_DIR/$SCRIPT_NAME" chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

cat > "$LAUNCHER_DIR/AppImageManager.desktop" <<EOF

[Desktop Entry] Name=AppImage Manager Exec=$INSTALL_DIR/$SCRIPT_NAME Icon=system-software-install Type=Application Categories=Utility; Terminal=false EOF

chmod +x "$LAUNCHER_DIR/AppImageManager.desktop"
cp "$LAUNCHER_DIR/AppImageManager.desktop" "$DESKTOP_DIR/AppImageManager.desktop"
chmod +x "$DESKTOP_DIR/AppImageManager.desktop"
log "Created shortcut for AppImage Manager"

}

install_from_github() { mkdir -p "$INSTALL_DIR" curl -L "$REPO_URL/raw/main/appimage_manager.sh" -o "$INSTALL_DIR/$SCRIPT_NAME" chmod +x "$INSTALL_DIR/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME" }

Entry point

install_dependencies if [[ "$1" == "--github" ]]; then install_from_github else create_manager_shortcut main_menu fi

