{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;

    style = ''
      * {
        font-family: "Terminus";
        font-size: 16px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: #0a0a0a;
        color: #cc3333;
      }

      #clock, #pulseaudio, #network, #workspaces {
        padding: 0 10px;
        color: #5a3693;
        background-color: #0a0a0a;
      }

      #workspaces button {
        color: #5a3693;
        padding: 0 5px;
        background-color: transparent;
      }

      #workspaces button.focused {
        color: #cc3333;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "sway/workspaces" "mpris" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" ];

        clock = {
          format = "{:%Y-%m-%d %I:%M %p}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        network = {
          format-ethernet = "ETH";
          format-wifi = "WiFi {signalStrength}%";
          format-disconnected = "DISCONNECTED";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "MUTED";
          on-click = "foot -e pulsemixer";
        };

        mpris = {
          format = "> {artist} — {title}";
          format-paused = "= {artist} — {title}";
        };
      };
    };
  };
}
