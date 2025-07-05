# AppImage Manager

A lightweight GUI-based AppImage installer/uninstaller for Linux using zenity.

Features

✅ Install any .AppImage file to /opt/<AppName>

✅ Automatically create Start Menu and Desktop shortcuts

✅ Optional icon support for each app

✅ Uninstall with a simple GUI

✅ View installation logs

✅ Fully self-contained, no root access needed except for installing to /opt



---

Installation

1. One-Line Installer

bash <(curl -s https://raw.githubusercontent.com/AirysDark/appimage-manager/main/appimage_manager.sh)

2. Manual Install

git clone '''https://github.com/AirysDark/appimage-manager.git
cd appimage-manager
chmod +x appimage_manager.sh
./appimage_manager.sh'''


---

Usage

After launching the script, you'll be presented with a Zenity-powered GUI:

Install AppImage: Choose an AppImage file, give it a name, optionally select an icon.

Uninstall AppImage: Select from a list of installed AppImages.

List Installed AppImages: View current installs in /opt.

View Install Log: See what apps you've installed/uninstalled.


A launcher for the AppImage Manager itself will also be added to your Start Menu and Desktop.


---

Dependencies

zenity


Install with:

sudo apt install zenity


---

License

MIT


---

Screenshots (Optional)

Add screenshots of the UI here.


---

Contributing

Pull requests welcome! If you'd like to help improve the UI, add features, or improve detection/icon integration, feel free to fork the project and send a PR.


---

Credits

Created by AirysDark.
