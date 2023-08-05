{pkgs, ...}: let
  fish_config = builtins.readFile ./config.fish;
in {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${fish_config}
    '';
    shellAliases = {
      rusty-man = "rusty-man --viewer tui";
      unset = "set --erase";
      neovim = "nvim";
      ls = "exa -al --color=always --group-directories-first --icons";
      # all files and dirs
      la = "exa -a --color=always --group-directories-first --icons";
      # long format
      ll = "exa -l --color=always --group-directories-first --icons";
      # tree listing
      lt = "exa -aT --color=always --group-directories-first --icons";
      # show only dotfiles
      "l." = "exa -a | egrep '^\\.'";
      ip = "ip -color";
      qqq = "exit";
      # Replace some more things with better alternatives
      cat = "bat --style header --style snip --style changes --style header";
      grubup = "sudo update-grub";
      tarnow = "tar -acf ";
      untar = "tar -xvf ";
      wget = "wget -c";
      psmem = "ps auxf | sort -nr -k 4";
      psmem10 = "ps auxf | sort -nr -k 4 | head -10";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      jctl = "journalctl -p 3 -xb";
    };

    functions = {
      history = {
        body = "builtin history --show-time='%F %T '";
      };
      fish_prompt = {
      body = "starship";
      };
      backup = {
        argumentNames = "filename";
        body = "cp $filename $filename.bak";
      };
      copy = {
        body = ''
          set count (count $argv | tr -d \n)
          if test "$count" = 2; and test -d "$argv[1]"
              set from (echo $argv[1] | trim-right /)
              set to (echo $argv[2])
              command cp -r $from $to
          else
              command cp $argv
          end
        '';
      };
      __history_previous_command = {
        body = ''
           switch (commandline -t)
                 case "!"
                     commandline -t $history[1]
                     commandline -f repaint
                 case "*"
                     commandline -i !
          end

        '';
      };
      __history_previous_command_arguments = {
        body = ''
          switch (commandline -t)
              case "!"
                  commandline -t ""
                  commandline -f history-token-search-backward
              case "*"
                  commandline -i '$'
          end

        '';
      };
    };
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "master";
          sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
      {
        name = "wakatime-fish";
        src = pkgs.fishPlugins.wakatime-fish.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
  };
}
