{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
    ];

    extraPackages = with pkgs; [
      nixd
    ];

    userSettings = {
      relative_line_numbers = true;
      file_finder = {
        modal_width = "medium";
      };
      tab_bar = {
        show = true;
      };
      tabs = {
        show_diagnostics = "errors";
      };
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };
      # centered_layout = {
      #   left_padding = "0.15";
      #   right_padding = "0.15";
      # };
      inlay_hints = {
        enabled = true;
      };
      inactive_opacity = "0.5";
      auto_install_extensions = true;
      outline_panel = {
        dock = "right";
      };
      collaboration_panel = {
        dock = "left";
      };
      notification_panel = {
        dock = "left";
      };
      chat_panel = {
        dock = "left";
      };

      assistant = {
        enabled = false;
        version = "2";
        default_open_ai_model = null;

        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };
      };

      node = {
        path = lib.getExe pkgs.nodejs_22;
        npm_path = lib.getExe' pkgs.nodejs_22 "npm";
      };

      # hour_format = "hour12";
      auto_update = false;
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          EDITOR = "zed --wait";
          TERM = "alacritty"; # or kitty etc
        };
        font_family = "JetBrainsMono Nerd Font";
        font_features = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };
      # File syntax highlighting
      file_types = {
        JSON = [
          "json"
          "jsonc"
          "*.code-snippets"
        ];
      };
      languages = {
        Nix.language-servers = ["nixd" "!nil"];
      };

      lsp = {
        settings = {
          # This is for other LSP servers, keep it separate
          dialyzerEnabled = true;
        };

        nix = {
          binary.path_lookup = true;
        };

        # "rust-analyzer" = {
        #   # Quote the LSP name
        #   binary = {
        #     # run `which rust-analyzer`
        #     path = ""/nix/store/3i6z4bh7ffyj99drw554nsmnspyizky6-rust-default-1.87.0-nightly-2025-02-18/bin/rust-analyzer";
        #   };
        #   settings = {
        #     diagnostics = {
        #       enable = true;
        #       styleLints = {
        #         enable = true;
        #       }; # Corrected styleLints access
        #     };
        #     checkOnSave = true;
        #     check = {
        #       command = "clippy";
        #       features = "all";
        #     };
        #     cargo = {
        #       buildScripts = {
        #         enable = true;
        #       }; # Corrected buildScripts access
        #       features = "all";
        #     };
        #     inlayHints = {
        #       bindingModeHints = {
        #         enable = true;
        #       }; # Corrected access
        #       closureStyle = "rust_analyzer";
        #       closureReturnTypeHints = {
        #         enable = "always";
        #       }; # Corrected access
        #       discriminantHints = {
        #         enable = "always";
        #       }; # Corrected access
        #       expressionAdjustmentHints = {
        #         enable = "always";
        #       }; # Corrected access
        #       implicitDrops = {
        #         enable = true;
        #       };
        #       lifetimeElisionHints = {
        #         enable = "always";
        #       }; # Corrected access
        #       rangeExclusiveHints = {
        #         enable = true;
        #       };
        #     };
        #     procMacro = {
        #       enable = true;
        #     };
        #     rustc = {
        #       source = "discover";
        #     };
        #     files = {
        #       excludeDirs = [
        #         "".cargo"
        #         "".direnv"
        #         "".git"
        #         "node_modules"
        #         "target"
        #       ];
        #     };
        #   };
        # }; # rust-analyser
      };
    };
  };
}
