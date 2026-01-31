## About
The script is designed to remove Snap packages and the Snapd service from an Ubuntu system and replace it with Firefox from Mozilla's APT repository. It first prompts the user for confirmation before removing Snap packages and the Snapd service, including stopping and disabling the Snapd service, purging the Snapd package, and deleting Snap-related directories. After Snap is removed, it creates a preference file to prevent Snapd from being reinstalled. The script then prompts the user again to confirm if they want to install Firefox, adds Mozilla’s APT repository, and installs Firefox. Lastly, it optionally installs the Gnome App Store if the user agrees. The script includes error handling to ensure each step completes successfully and provides feedback if something goes wrong.

## What's different in this fork ?
Added flatpak integration , so you can directly install flatpak after snap removal 

## How To Run
 1. Save the script 
   ```wget -L https://raw.github.com/praveenxsharma/ubuntu-debloat/main/remove_snap.sh```


2. You need to make the script executable. You can do this using the chmod command : \
   ```chmod +x remove_snap.sh ```

3. Now that the script is executable, you can run it. \
   Use the following command **(MUST RUN WITH ROOT PRIVILEGE FOR APT)** : \
   ```sudo ./remove_snap.sh```
4. Select yes to reboot if you installed flatpak.

## Optional Install
- [Firefox](https://www.firefox.com/)
    - [Extended Support Release](https://wiki.mozilla.org/Enterprise/Firefox/ExtendedSupport:Proposal) or Rapid(Normal) Release
- [Gnome Software Center](https://apps.gnome.org/en/Software/)
- [Flatpak](https://flatpak.org/)

## Which Ubuntu Version It Support?
It supports every Ubuntu version with snap until now.

## Disclaimer
Ubuntu is a registered trademark of Canonical Ltd.  
This project is not affiliated with, endorsed by, or sponsored by Canonical Ltd or the Ubuntu project.

---
**TAKE BACKUP OF SYSTEM AND USE AT YOUR OWN RISK**
