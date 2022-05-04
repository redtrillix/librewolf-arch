## The official Arch Linux Package Build for the LibreWolf Browser

### Building from source

If you're on Arch Linux, you can use this repository to build the LibreWolf Browser from source.

The build process will take a long time, even on powerful machines, it takes about an hour. On weaker computers, it can take way longer.
If you still want to build it yourself, follow the steps below.

First clone and enter this repository:

`git clone https://gitlab.com/librewolf-community/browser/arch.git && cd arch/`

Then import Mozilla's GPG key:

`gpg --recv-key EBE41E90F6F12F6D`

Finally resolve dependencies, build and install the package:

`makepkg -si`



### AUR packages

To make your life easier, use the packages provided via the AUR:

 - [librewolf](https://aur.archlinux.org/packages/librewolf): build from source; again, it will take a long time
 - [librewolf-bin](https://aur.archlinux.org/packages/librewolf-bin): spare the time and work, download the binary

