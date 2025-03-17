# My glorious Git configuration
# Some options taken from https://news.ycombinator.com/item?id=43138368
# Some aliases copied from multiple sources that I did not take notes.
{
  machine,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Heitor Pascoal de Bittencourt";
    userEmail = "heitorpbittencourt@gmail.com";
    signing = lib.mkIf (machine.gitKey != null) {
      key = machine.gitKey;
      signByDefault = true;
      # TODO usse ssh key?
    };
    ignores = [
      # Direnv stuff
      ".direnv/"
    ];
    aliases = {
      # List aliases
      alias = "! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ / | grep -v ^'alias '";

      # Nice looking git log --graph
      l = "log --graph --decorate --pretty=format:'%C(blue)%d%Creset %C(yellow)%h%Creset %s, %C(bold green)%an%Creset, %C(green)%cd%Creset' --date=relative -n 20";
      graph = "log --graph --decorate --pretty=format:'%C(blue)%d%Creset %C(yellow)%h%Creset %s, %C(bold green)%an%Creset, %C(green)%cd%Creset' --date=relative --all";

      # Find commits by commit message ('log --grep') in "short mode"
      lg = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f";
      # Find commits by source code a.k.a 'find code'
      fc = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f";

      # View the current working tree status using the short format
      s = "status -s";

      # Commit staged changes
      c = "commit --verbose";
      # Commit all changes
      ca = "commit --all --verbose";

      # Show diff
      d = "!git --no-pager diff --patch-with-stat";

      # Change date of last commit to now
      now = "commit --amend --date=now";

      # Show verbose output about tags, branches or remotes
      tags = "tag -l";
      branches = "branch -a";
      remotes = "remote -v";

      # List contributors with number of commits
      contributors = "shortlog --summary --numbered";

      # Remove branches that have already been merged with master a.k.a. ‘delete merged’
      dm = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";
    };
    extraConfig = {
      branch = {sort = "-committerdate";};
      column = {ui = "auto";};
      commit = {
        gpgsign = machine.gitKey != null;
        verbose = true;
      };
      core = {editor = "nvim";};
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = "copies";
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      grep = {patternType = "perl";};
      help = {autocorrect = "prompt";};
      init = {defaultBranch = "main";};
      merge = {
        conflictStyle = "diff3";
        log = 20;
        tool = "nvimdiff";
      };
      pull = {ff = "only";};
      rerere = {
        autoupdate = true;
        enabled = true;
      };
      tag = {
        gpgsign = machine.gitKey != null;
        sort = "version:refname";
      };
    };
  };
}
