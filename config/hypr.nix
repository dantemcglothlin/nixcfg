{ lib, config, pkgs, ... }:
{
    home.packages = with pkgs; lib.mkIf config.wayland.windowManager.hyprland.enable [ wl-clipboard ];

    wayland.windowManager.hyprland = {
        settings = {
            exec-once = [
                "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store"
                "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store"
            ];

            input.touchpad = {
                disable_while_typing = false;
            };

            general = {
                "col.active_border" = "0xFF575757";
                "gaps_out" = 10;
            };

            decoration = {
                rounding = 8;

                shadow = {
                    range = 6;
                };

                blur = {
                    new_optimizations = true;
                    special = false;
                    size = 10;
                    passes = 3;
                    brightness = 1;
                    noise = 0.01;
                    contrast = 1.4;
                    popups = true;
                    popups_ignorealpha = 0.6;
                };
            };

            blurls = [ "popup_window" ];
            layerrule = [
                "ignorezero, popup_window"
                "blurpopups, popup_window"
                "blur, bar"
                "blurpopups, bar"
                "ignorezero, bar"
            ];

            windowrulev2 = [
                "opacity 0.95 0.95,class:^(code)$"
                "noblur, class:^(?!(code))"
            ];

            misc = {
                disable_hyprland_logo = true;
            };

            "$mod" = "SUPER";
            bind = [
                "$mod, Return, exec, ${pkgs.alacritty}/bin/alacritty"
                "$mod, D, exec, ${pkgs.bemenu}/bin/bemenu-run"

                "$mod, V, exec, ${pkgs.cliphist}/bin/cliphist list | bemenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"

                "$mod, F, fullscreenstate, -1, 2"
                "$mod SHIFT, F, fullscreenstate, 2, 2"

                "$mod, R, submap, resize"
                "$mod SHIFT, Q, killactive"

                "$mod, TAB, togglespecialworkspace"
                "$mod SHIFT, TAB, movetoworkspace, special"

                "$mod, SPACE, togglefloating"
                "$mod SHIFT, SPACE, pin"

                "$mod, LEFT, movewindow, l"
                "$mod, RIGHT, movewindow, r"
                "$mod, UP, movewindow, u"
                "$mod, DOWN, movewindow, d"
            ] ++ (
                builtins.concatLists (builtins.genList (ws: [
                    "$mod, ${toString ws}, workspace, ${toString ws}"
                    "$mod SHIFT, ${toString ws}, movetoworkspace, ${toString ws}"
                    "$mod SHIFT ALT, ${toString ws}, movetoworkspacesilent, ${toString ws}"
                ]) 10)
            );
            bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
                "$mod SHIFT, mouse:272, resizewindow"
                "$mod SHIFT, mouse:273, resizewindow"
            ];
        };
        extraConfig = ''
            submap = resize
            binde = , RIGHT, resizeactive, 50 0
            binde = , UP, resizeactive, 0 50
            binde = , LEFT, resizeactive, -50 0
            binde = , DOWN, resizeactive, 0 -50
            bind = , ESCAPE, submap, reset
            submap = reset
        '';
    };


    xdg.configFile."hypr/xdph.conf".text = ''
        screencopy {
            allow_token_by_default = true
            max_fps = 144
        }
    '';
}
