{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # First param
      username = {
        format = " [╭─$user]($style)@";
        show_always = true;
        style_root = "bold red";
        style_user = "bold red";
      };
      # Second param
      hostname = {
        disabled = true;
      };
      #Third param
      directory = {
        style = "purple italic bold";
        truncate_to_repo = true;
        truncation_length = "0";
        truncation_symbol = "repo: ";
      };
      sudo = {
        disabled = false;
      };
      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        deleted = "x";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        style = "white";
      };
      cmd_duration = {
        disabled = false;
        format = "took [$duration]($style)";
        min_time = 1;
      };
      ## SECOND LINE/ROW: Prompt
      # Somethere at the beginning

      battery = {
        charging_symbol = "";
        disabled = true;
        discharging_symbol = "";
        full_symbol = "";

        display = {
          disabled = false;
          style = "bold red";
          threshold = 15;
        };
      };
    };
  };
}
