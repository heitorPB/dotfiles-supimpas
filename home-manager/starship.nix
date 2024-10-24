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
        $battery$username$sudo(at) $hostname$directory$git_branch$git_status$python$nix_shell $direnv
        $character
      '';

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
        format = " [$symbol]($style)";
      };

      hostname = {
        ssh_only = false;
        disabled = false;
        ssh_symbol = " 🌐";
        format = "[$hostname$ssh_symbol]($style) in ";
      };

      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
      };

      # Python venv
      python = {
        disabled = false;
        symbol = "🐍";
        format = "[$symbol $pyenv_prefix($version )(\($virtualenv\) )]($style)";
      };

      nix_shell = {
        disabled = false;
        symbol = "❄️";
        format = "[$symbol$state( \($name\))]($style)";
        impure_msg = "impure";
        pure_msg = "";
      };

      direnv = {
        disabled = false;
        format = "[$symbol$loaded/$allowed]($style)";
      };

      # TODO: disable all other blocks?
    };
  };
}
