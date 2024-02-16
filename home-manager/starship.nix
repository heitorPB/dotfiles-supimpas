# Starship configuration for PS1/PS2
{ ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableIonIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      format = ''
        $battery$username$sudo at $hostname$directory$git_branch$git_status$direnv
        $character
      '';

      # TODO: add nix shell block

      # Each block config below
      battery = {
        format = "[\\($symbol$percentage\\)]($style) ";
        full_symbol = "";
        charging_symbol = "+";
        discharging_symbol = "-";
        display = [
          { threshold = 15; style = "bold red"; }
          { threshold = 30; style = "bold yellow"; }
          { threshold = 80; style = "bold green"; }
          { threshold = 100; style = "bold green"; }
        ];
      };

      username = {
        show_always = true;
        format = "[$user]($style)";
      };

      sudo = {
        disabled = false;
        symbol = "☢️";
        style = "bold bright-red";
        format = "[ $symbol]($style)";
      };

      hostname = {
        ssh_only = false;
        disabled = false;
      };

      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
      };

      # TODO: direnv is buggy with starsgip <1.18:
      # https://github.com/starship/starship/pull/5684
      direnv.disabled = false;

      # TODO: disable all other blocks?
    };
  };
}

