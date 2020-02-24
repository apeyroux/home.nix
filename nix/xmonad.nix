with import <nixpkgs> {};

{
  home.packages = [
    alacritty
    emacs-all-the-icons-fonts # font pour le status bar
    feh
    gnome3.defaultIconTheme
    kitty
    libnotify # pour le test
    masterpdfeditor
    pavucontrol
    vlc
    xmobar
  ];

  programs.termite = {
    enable = true;
    backgroundColor = "#282c34";
    foregroundColor = "#eaeaea";
    foregroundBoldColor = "#ccd4e3";
    cursorColor = "#ff1493";
    dynamicTitle = true;
    clickableUrl = true;
    fullscreen = true;
    mouseAutohide = true;
    colorsExtra = ''
# black
color0  = #000000
color8  = #4d4d4d

# red
color1  = #ff5555
color9  = #ff6e67

# green
color2  = #50fa7b
color10 = #5af78e

# yellow
color3  = #f1fa8c
color11 = #f4f99d

# blue
color4  = #1f5582
color12 = #61afef

# magenta
color5  = #ff79c6
color13 = #ff92d0

# cyan
color6  = #8be9fd
color14 = #9aedfe

# white
color7  = #bfbfbf
color15 = #e6e6e6
    '';
  };

  services.udiskie = {
    enable = true;
    tray = "always";
  };

  services.dunst = {
    enable = true;
    settings = {
      frame = {
        width = 0;
        color = "#227195";
      };
      urgency_low = {
        background = "#4a5260";
        foreground = "#eaeaea";
        timeout = 10;
      };
      urgency_normal = {
        background = "#4a5260";
        foreground = "#eaeaea";
        timeout = 10;
      };
      urgency_critical = {
        background = "#ff1493";
        foreground = "#000000";
        timeout = 0;
      };

      global = {
        # The format of the message.  Possible variables:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        format = "%a\n<b>%s</b>\n%b\n%p";
        geometry = "400x5-15-65";

        font = "Roboto 10";
        allow_markup = "yes";
        plain_text = "no";
        sort = "yes";
        indicate_hidden = "yes";
        alignment = "center";
        bounce_freq = 0;
        show_age_threshold = 60;
        word_wrap = "yes";
        ignore_newline = "no";
        transparency = 40;
        shrink = "no";
        monitor = 0;
        follow = "none";
        show_indicators = "no";
        line_height = 0;
        notification_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        separator_color = "frame";
        icon_position = "left";
        idle_threshold = 120;
        sticky_history = "yes";
        history_length = 20;
        startup_notification = false;
        browser = "google-chrome -new-tab";
      };

      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+shift+l";
      };
    };
  };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = p: [
      p.xmonad
      # p.taffybar
      p.xmobar
      p.xmonad-extras
      p.xmonad-contrib
      p.xmonad-volume
      p.xmonad-utils
      p.xmonad-screenshot
      p.xmonad-wallpaper
      p.xmonad-spotify
    ];
    config = ../dotfiles/xmonad.hs;
  };
}
