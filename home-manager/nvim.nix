# My neovim settings
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      # Tree-sitter, its grammars, and Lua configuration
      {
        plugin = (nvim-treesitter.withPlugins (plugins: with plugins; [
          bash
          dockerfile
          git_rebase
          gitattributes
          hcl
          json
          ledger
          markdown
          nix
          python
          regex
          rst
          rust
          toml
          vim
          yaml
        ]));
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true,
            },
            indent = {
              enable = true,
            },
          }
        '';
      }

      # LSP
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require('lspconfig')

          function add_lsp(binary, server, options)
            if vim.fn.executable(binary) == 1 then server.setup(options) end
          end

          add_lsp("bash-language-server", lspconfig.bashls, {})
          add_lsp("pylsp", lspconfig.pylsp, {})
          add_lsp("rnix-lsp", lspconfig.rnix, {})

          -- Mappings
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
          vim.keymap.set("n", "<space>f", vim.lsp.buf.format, { desc = "Format code" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })

          -- Diagnostic
          vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
          vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { desc = "Diagnostics on loclist" })
          -- vim.keymap.set("n", "gq", vim.diagnostic.setqflist, { desc = "Diagnostics on quickfix" })
        '';
      }

      # Completion plugins for LSP
      cmp-nvim-lsp
      cmp-buffer
      lspkind-nvim
      {
        plugin = nvim-cmp;
        type = "lua";
        config = /* lua */ ''
          local cmp = require('cmp')

          cmp.setup{
            formatting = { format = require('lspkind').cmp_format() },
            -- Same keybinds as vim's vanilla completion
            mapping = {
              ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
              ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
              ['<C-e>'] = cmp.mapping.close(),
              ['<C-y>'] = cmp.mapping.confirm(),
            },
            sources = {
              { name='buffer', option = { get_bufnrs = vim.api.nvim_list_bufs } },
              { name='nvim_lsp' },
              { name='orgmode' },
            },
          }
        '';
      }

      # Color theme
      vim-colors-solarized

      # Improve Nix'ing: syntax highlight, filetype detection, indentation
      rust-vim
      vim-markdown
      vim-nix
      vim-toml

      # vimwiki with vim-zettel
      # This plugin pulls vimwiki, fzf-vim, and fzf plugins
      vim-zettel
    ];

    # My forever configs for .config/nvim/init.vim
    extraConfig = ''
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
      " use [[file|title]] for internal links
      let g:zettel_link_format = "[[%link|%title]]"
    '';
  };
}
