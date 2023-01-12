# Kitty Theme Browser

A simple perl script to preview and set Kitty themes directly from your terminal.

It previews the theme using Kitty's remote control facility, and sets the theme permanently by creating the theme.conf symbolic link.

## Dependencies
* you'll need some themes - start here https://github.com/dexpota/kitty-themes
* Kitty needs remote control enabled ...
  + edit ~/.config/kitty/kitty.conf
  + search for allow_remote_control and set it to yes

## Installation    
```
git clone https://github.com/eggmceye/kitty-theme-browser
cd kitty-theme-browser
./kittythemebrowser
```
## Usage
* use + or - to move back and forward through the themes
* hit letter & number keys to jump to a theme name
* hit enter to set permanently
