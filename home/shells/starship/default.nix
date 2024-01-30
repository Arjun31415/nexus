{
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      format = lib.strings.concatStrings [
        " [╭](bold fg:purple)"
        "$username"
        "[](bold fg:purple)"
        "[─](bold fg:#9db4fb)"
        "$directory"
        "[](bold fg:#9db4fb)"
        "([─](bold fg:#93bcfc)$git_branch$git_status[](bold fg:#8cc2fd))"
        "([─](bold fg:cyan)$cmd_duration[](bold fg:cyan)) "
        "$nix_shell"
        "$python"
        "$rust"
        "$c"
        "$cmake"
        "$golang"
        "$lua"
        "$nodejs"
        "$java"
        "\n"
        " $character"
      ];
      username = {
        format = "[$user]($style)";
        show_always = true;
        style_user = "bold bg:purple fg:black";
      };
      hostname = {
        disabled = true;
      };
      directory = {
        format = "[$path]($style)";
        style = "fg:black bg:#9db4fb italic bold";
        truncate_to_repo = true;
        truncation_length = 0;
      };
      git_branch = {
        symbol = "";
        format = "[$symbol $branch ]($style)";
        style = "bold fg:black bg:#93bcfc";
      };

      git_status = {
        #format = "([\\[$all_status$ahead_behind\\]]($style)(bold fg:#8cc2fd)─(bold fg:#8cc2fd))";
        format = "([\\[$all_status$ahead_behind\\]]($style))";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        deleted = "x";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        style = "bg:#8cc2fd fg:black";
      };
      cmd_duration = {
        disabled = false;
        format = "[took $duration]($style)";
        style = "bg:cyan fg:black";
        min_time = 1;
      };
      ## SECOND LINE/ROW: Prompt
      # Somethere at the beginning

      battery = {
        charging_symbol = "";
        disabled = true;
        discharging_symbol = "";
        full_symbol = "";

        display = [
          {
            disabled = false;
            style = "bold red";
            threshold = 15;
          }
          {
            disabled = false;
            style = "bold yellow";
            threshold = 50;
          }
        ];
      };
      time = {
        disabled = true;
        format = " 🕙 $time($style)\n";
        style = "bright-white";
        time_format = "%T";
      };
      character = {
        error_symbol = "[╰×](bold red)";
        #        success_symbol = "[╰─λ](bold red)";
        success_symbol = "[╰](bold red)";
      };
      status = {
        disabled = false;
        format = "[\\[$symbol$status_common_meaning$status_signal_name$status_maybe_int\\]]($style)";
        map_symbol = true;
        pipestatus = true;
        symbol = "🔴";
      };
      aws.symbol = " ";
      conda.symbol = " ";
      dart.symbol = " ";
      docker_context = {
        symbol = " ";
      };
      elixir = {
        symbol = " ";
      };
      golang = {
        symbol = " ";
      };
      # Mercurial
      hg_branch = {
        symbol = " ";
      };

      java = {
        symbol = " ";
      };

      julia = {
        symbol = " ";
      };

      nix_shell = {
        symbol = " ";
      };

      nodejs = {
        symbol = " ";
      };

      package = {
        symbol = " ";
      };

      perl = {
        symbol = " ";
      };

      php = {
        symbol = " ";
      };

      python = {
        symbol = " ";
      };

      ruby = {
        symbol = " ";
      };

      rust = {
        symbol = " ";
      };

      swift = {
        symbol = "ﯣ ";
      };

      lua = {
        symbol = " ";
      };
    };
  };
}
