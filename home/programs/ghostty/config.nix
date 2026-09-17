{ device ? "saffron", ... }:
let
  deviceConfig = if device == "saffron" then ''
    font-size = 17
    window-decoration = none
    # background-image = /home/crocus/Pictures/Wallpapers/mahuyu_26_birthday.jpg
    # background-image-fit = cover
    # background-image-opacity = 0.1
    background-opacity = 0.8
    background-blur = true
  '' else if device == "freesia" then ''
    font-size = 17
    macos-titlebar-style = hidden
    macos-option-as-alt = true
    # background-image = /Users/crocus/works/Wallpapers/cho-kaguya_concept01c.png
    # background-image-fit = cover
    # background-image-opacity = 0.1
    background-opacity = 0.8
  '' else if device == "surface" then ''
    font-size = 12
  '' else '''';
in
{
  xdg.configFile."ghostty/config".text = ''
    font-family = Mononoki Nerd Font
    font-family = Kosugi Maru

    working-directory = home
    window-inherit-working-directory = false
    shell-integration-features = ssh-terminfo,ssh-env

    ${deviceConfig}
  '';
}
