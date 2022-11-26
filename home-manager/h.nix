{gitKey ? null}:
{ config, inputs, lib, pkgs, ... }: with lib; {
  imports = [
    # ./nvim.nix
  ];

  # home.packages = with pkgs; [ steam ];

  # Configuration for git
  programs.git = {
    enable = true;
    userName = "Heitor Pascoal de Bittencourt";
    userEmail = "heitorpbittencourt@gmail.com";
    signing = mkIf (gitKey != null) {
      key = gitKey;
      signByDefault = true;
    };
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

      # Change date of last commit to now
      now = "commit --ammend --date=now";

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
      commit = { gpgsign = gitKey != null; };
      core = { editor = "nvim"; };
      diff = { renames = "copies"; };
      fetch = { prune = true; };
      help = { autocorrect = 1; };
      init = { defaultBranch = "main"; };
      merge = { log = 20; tool = "nvimdiff"; };
      pull = { ff = "only"; rebase = true; };
      rerere = { enabled = true; };
      tag = { gpgsign = gitKey != null; };
    };
  };

  # My neovim settings
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      tree-sitter
      tree-sitter-grammars.tree-sitter-bash
      tree-sitter-grammars.tree-sitter-markdown
      tree-sitter-grammars.tree-sitter-nix
      tree-sitter-grammars.tree-sitter-rst
    ];
    plugins = with pkgs.vimPlugins; [
      vim-colors-solarized

      nvim-treesitter

      vimwiki
      fzf-vim # Does this one pull the fzf plugin?
      # vim-zettel
    ];
    # My forever configs for .config/nvim/init.vim
    extraConfig = ''
      "colorscheme rebecca-dark
      colorscheme solarized

      let mapleader=","

      set number       " always shows line numbers
      set colorcolumn=80
      set clipboard+=unnamedplus
      set ignorecase   " Ignore case of searches
      set smartcase    " no ignorecase if Uppercase char present
      set mouse=a      " enable mouse in all modes
      set title        " Show the filename in the window titlebar
      set scrolloff=3  " Start scrolling 3 lines before the horizontal window border
      set nofoldenable " disable auto folding
      set autoindent   " Automatic indentation
      set smartindent  " Make it smart
      set autochdir    " Change current working dir to the file's dir

      " show trailing spaces and tabs
      set listchars=tab:▸\ ,trail:·,nbsp:_
      set list

      " Open new split panes to right and bottom, which feels more natural
      set splitbelow
      set splitright

      " text formatting
      set formatoptions+=t " Auto-wrap text using textwidth
      set formatoptions+=c " same for comments
      set formatoptions+=q " Allow formatting of comments with 'gq'
      set formatoptions-=l " make it work for older text

      " Quicker window movement with ctrl-w + hjkl
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>

      " define csv filetype
      autocmd BufNewFile,BufRead *csv set filetype=csv

      autocmd FileType csv set textwidth=0       " disable line wdraps for csv
      autocmd FileType markdown set textwidth=79 " make text break lines at 79 chars
      autocmd FileType yaml set ts=2 sts=2 sw=2 expandtab foldmethod=indent " magic

      " Strip trailing whitespace (,ss)
      function! StripWhitespace()
      	let save_cursor = getpos(".")
      	let old_query = getreg('/')
      	:%s/\s\+$//e
      	call setpos('.', save_cursor)
      	call setreg('/', old_query)
      endfunction
      noremap <leader>ss :call StripWhitespace()<CR>

      " vimwiki magic
      let garden_wiki = {}
      let garden_wiki.path = '~/vimwiki'
      let garden_wiki.name = 'garden'
      let garden_wiki.syntax = 'markdown'
      let garden_wiki.ext = 'md'
      let garden_wiki.auto_tags = 1
      let garden_wiki.links_space_char = '-'
      let g:vimwiki_list = [garden_wiki]
      " no temporary wikis
      let g:vimwiki_global_ext = 0

      " add keywords to default zettel YAML tags
      let front_matter = {}
      let front_matter.front_matter = {}
      let front_matter.front_matter.keywords = []
      let front_matter.front_matter.draft = "false"
      let g:zettel_options = [front_matter]
      " change default new filename to date-title.md
      let g:zettel_format = "%title"
      " use [[bla|title]] for internal links
      let g:zettel_link_format = "[[%link|%title]]"
    '';
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
