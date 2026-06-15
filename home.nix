{ config, pkgs, ... }:
{
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    terminus_font
    playerctl
    libnotify
    arrpc
    lf
    bemenu
    j4-dmenu-desktop
    swayidle
    xdg-desktop-portal-termfilechooser
    chafa
    file
    swaylock-effects
    gtklock
    gtklock-userinfo-module
  ];

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${config.home.homeDirectory}/.config/xdg-desktop-portal-termfilechooser/lf-wrapper.sh
  '';

  xdg.configFile."xdg-desktop-portal-termfilechooser/lf-wrapper.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      multiple="$1"
      directory="$2"
      save="$3"
      path="$4"
      out="$5"
      foot --app-id=filechooser -- sh -c "LF_CHOOSER_FILE='$out' lf '$path'"
    '';
  };

  xdg.configFile."lf/lfrc".text = ''
    set previewer ~/.config/lf/previewer
    set sixel true

    cmd open &{{
      if [ -n "$LF_CHOOSER_FILE" ]; then
        echo "$f" > "$LF_CHOOSER_FILE"
        lf -remote "send $id quit"
      else
        xdg-open "$f"
      fi
    }}
  '';

  xdg.configFile."lf/previewer" = {
    executable = true;
    text = ''
      #!/bin/sh
      case "$(file -Lb --mime-type -- "$1")" in
        image/*) chafa -f sixel -s "$2x$3" --animate off --polite on -t 1 --bg black "$1" ;;
        text/*) cat "$1" ;;
      esac
    '';
  };

  imports = [
    ./sway.nix
    ./waybar.nix
    ./foot.nix
    ./mako.nix
    ./scripts.nix
  ];
  xdg.configFile."gtklock/config.ini".text = '';
    [main]
    modules = clock-module.so
    time-format = %I:%M:%S %p

    [clock-module]
  '';

  xdg.configFile."gtklock/style.css".text = '';
    window {
      background-color: #000000;
    }

    #clock-label {
      font-family: "Terminus";
      font-size: 24px;
      color: #8b3a5a;
    }

    #body {
      background-color: #000000;
    }

    #unlock-button {
      background-color: #000000;
      border: 1px solid #8b3a5a;
      color: #8b3a5a;
      font-family: "Terminus";
      font-size: 12px;
    }

    entry {
      background-color: #000000;
      border: 1px solid #8b3a5a;
      color: #8b3a5a;
      font-family: "Terminus";
      font-size: 12px;
      caret-color: #8b3a5a;
    }

    label {
      font-family: "Terminus";
      font-size: 12px;
      color: #8b3a5a;
    }
  '';
}
