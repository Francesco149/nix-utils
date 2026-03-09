{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wofi # launcher
    kitty # terminal
    font-awesome # icon font
    nerd-fonts.jetbrains-mono
    nautilus
    maim
    eog # image viewer
    vlc
    grimblast # screenshot
    icon-library # browse icon themes
    swappy # screenshot annotator
    pwvucontrol # volume control
  ];

  fonts.fontconfig.enable = true;
  services.dunst.enable = true; # notifications
  services.cliphist.enable = true; # clipboard manager

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  wayland.windowManager.hyprland.settings = {
    general = {
      "col.active_border" = "rgba(89b4fa60)";
      "col.inactive_border" = "rgba(31324400)";
    };
    exec-once = [
      "waybar"
      "kitty"
    ];
    "$mod" = "ALT";
    bind = [
      "$mod, Return, exec, kitty"
      "$mod, D, exec, wofi --show drun"
      "$mod, Q, killactive"
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
      "$mod, Print, exec, grimblast save area - | swappy -f -" # select region
      ", Print, exec, grimblast save screen - | swappy -f -" # full screen
      "$mod SHIFT, Print, exec, grimblast save active - | swappy -f -" # active window
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    decoration = {
      blur = {
        enabled = true;
        size = 8;
        passes = 2;
        vibrancy = 0.2;
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "cpu"
        "memory"
        "pulseaudio"
        "network"
        "battery"
        "custom/power"
      ];
      pulseaudio.format = "{icon} {volume}%";
      pulseaudio.format-icons.default = [
        ""
        ""
        "⏎"
      ];
      pulseaudio.on-click = "pwvucontrol";
      network.format-wifi = " {signalStrength}%";
      network.format-ethernet = "󰈀 {ipaddr}";
      network.format-disconnected = "⏎";
      battery.format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      clock.format = " {:%H:%M}";
      cpu.format = " {usage}%";
      memory.format = " {percentage}%";

      "custom/power" = {
        format = "⏻  ";
        on-click = ''
          choice=$(printf 'shutdown\nreboot\nlogout\nlock' | wofi --dmenu --prompt 'power')
          case $choice in
            shutdown) systemctl poweroff ;;
            reboot) systemctl reboot ;;
            logout) hyprctl dispatch exit ;;
            lock) hyprlock ;;
          esac
        '';
        tooltip = false;
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.65);
        color: #cdd6f4;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      #workspaces button {
        color: #6c7086;
        padding: 0 8px;
      }

      #workspaces button.active {
        color: #cdd6f4;
      }

      #clock, #network, #battery, #tray, #pulseaudio, #cpu, #memory {
        color: #6c7086;
        padding: 0 12px;
      }

      #custom-lock, #custom-logout {
        color: #f38ba8;
        padding: 0 8px;
      }
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      window_padding_width = 8;
      background_opacity = "0.65";

      foreground = "#CDD6F4";
      background = "#0E0E1E";
      cursor = "#F5E0DC";

      color0 = "#45475A";
      color1 = "#F38BA8";
      color2 = "#A6E3A1";
      color3 = "#F9E2AF";
      color4 = "#89B4FA";
      color5 = "#F5C2E7";
      color6 = "#94E2D5";
      color7 = "#BAC2DE";
      color8 = "#585B70";
      color9 = "#F38BA8";
      color10 = "#A6E3A1";
      color11 = "#F9E2AF";
      color12 = "#89B4FA";
      color13 = "#F5C2E7";
      color14 = "#94E2D5";
      color15 = "#A6ADC8";
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        blur_passes = 3;
        blur_size = 8;
        noise = 0.02;
        brightness = 0.6;
      };

      input-field = {
        size = "300, 50";
        outline_thickness = 2;
        outer_color = "rgb(1e1e2e)";
        inner_color = "rgb(313244)";
        font_color = "rgb(cdd6f4)";
        placeholder_text = "password";
        check_color = "rgb(a6e3a1)";
        fail_color = "rgb(f38ba8)";
      };

      label = {
        text = "$TIME";
        font_size = 48;
        color = "rgb(cdd6f4)";
        position = "0, 200";
        halign = "center";
        valign = "center";
      };
    };
  };

  # cool shell prompt
  programs.starship = {
    enable = true;
    settings =
      fromTOML (
        builtins.readFile (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/vipau/veeship/2144df930c898d64dffc3b44fe1f5ddb1564af69/starship.toml";
            sha256 = "05dmarzwhbxwc07had7pnjbjm2c8xkiakfcmr0w20d0vpqx4jjv5";
          }
        )
      )
      // {
        palette = "catppuccin_mocha";

        fill = {
          symbol = "─";
          style = "fg:overlay0";
        };

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
  };

  home.sessionVariables = {
    GTK_THEME = "Flat-Remix-GTK-Grey-Darkest";
    MOZ_GTK_TITLEBAR_DECORATION = "client";
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
      };
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Violet-Dark";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  # fancy neovim client
  programs.neovide.enable = true;

  programs.neovim = {
    enable = true;
    initLua = ''
      vim.g.neovide_padding_top = 8
      vim.g.neovide_padding_bottom = 8
      vim.g.neovide_padding_left = 8
      vim.g.neovide_padding_right = 8
    '';
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
      };
      modules = [
        "title"
        "os"
        "kernel"
        "packages"
        "shell"
        "nixstore"
      ];
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      echo ""
      echo "  ALT + Return         terminal"
      echo "  ALT + D              app launcher"
      echo "  ALT + Q              close window"
      echo "  ALT +         1-4    switch workspace"
      echo "  ALT + Shift + 1-4    move window to workspace"
      echo "  ALT + H/J/K/L        move focus"
      echo "  ALT + Left Drag      move window"
      echo "  ALT + Right Drag     resize window"
      echo "                Print  screenshot"
      echo "  ALT + Shift + Print  screenshot active window"
      echo "  ALT         + Print  screenshot region"
      echo ""
      echo " Edit your home.nix to remove or change this message"
      echo ""
    '';
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "text/plain" = "neovide.desktop";
      "text/html" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "image/png" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "video/mp4" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "audio/mpeg" = "vlc.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/octet-stream" = "neovide.desktop";
    };
  };

  # the latest stable NixOS version you first installed Home Manager.
  # you can check here at the time of install: https://status.nixos.org/
  # do not change this afterwards
  home.stateVersion = "25.11";
}
