# My neovim settings
{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      # Tree-sitter, all grammars, and Lua configuration
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config =
          /*
          lua
          */
          ''
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
        config =
          /*
          lua
          */
          ''
            local lspconfig = require('lspconfig')

            function add_lsp(server, options)
              -- if vim.fn.executable(binary) == 1 then
              --   server.setup(options)
              -- end
              if not options["cmd"] then
                options["cmd"] = server["document_config"]["default_config"]["cmd"]
              end
              if not options["capabilities"] then
                options["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
              end

              if vim.fn.executable(options["cmd"][1]) == 1 then
                server.setup(options)
              end
            end

            -- Basic configuration for some LSP servers
            add_lsp(lspconfig.ansiblels, {})
            add_lsp(lspconfig.bashls, {})

            local gopls_config = {
              settings = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                    -- fieldalignment = true, -- structs can use less memory if variables are aligned
                    unusedvariable = true,
                  },
                  staticcheck = true,
                  gofumpt = true,
                },
              },
            }
            add_lsp(lspconfig.gopls, gopls_config)

            local rust_analyzer_config = {
              settings = {
                ['rust-analyzer'] = {
                  diagnostics = {
                    enable = true;
                  }
                }
              }
            }
            add_lsp(lspconfig.rust_analyzer, rust_analyzer_config)

            -- add_lsp(lspconfig.pylsp, {})
            add_lsp(lspconfig.pyright, {})
            add_lsp(lspconfig.ruff, {})

            -- Nix LSP
            local nil_config = {
                autostart = true,
                capabilities = caps,
                cmd = { "nil" },
                settings = {
                    ["nil"] = {
                      formatting = { command = { "alejandra" }, },
                      nix = { flake = { autoArchive = true }, },
                    },
                },
            }
            add_lsp(lspconfig.nil_ls, nil_config)

            add_lsp(lspconfig.terraformls, {}) -- official from HashiCorp
            add_lsp(lspconfig.tflint, {}) -- TFLint, a Terraform linter and LSP
            add_lsp(lspconfig.nomad_lsp, {})

            add_lsp(lspconfig.vale_ls, {})

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
        config =
          /*
          lua
          */
          ''
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
              },
            }
          '';
      }

      # Color theme
      catppuccin-nvim

      # Improve Nix'ing: syntax highlight, filetype detection, indentation
      ansible-vim
      rust-vim
      vim-markdown
      vim-nix
      vim-terraform
      vim-toml

      # vimwiki with vim-zettel
      # This plugin pulls vimwiki, fzf-vim, and fzf plugins
      vim-zettel
    ];

    extraLuaConfig =  /* lua */ ''
      -- TODO: move mapleader here
      -- TODO: move colorscheme here

      vim.g.have_nerd_font = true

      vim.o.number = true -- always shows line numbers
      vim.o.relativenumber = false -- I don't like relative line numbering
      vim.o.mouse = 'a' -- Enable mouse in all modes

      -- Sync clipboard between OS and Neovim.
      --  Schedule the setting after `UiEnter` because it can increase startup-time.
      --  Remove this option if you want your OS clipboard to remain independent.
      --  See `:help 'clipboard'`
      vim.schedule(function()
        vim.o.clipboard = 'unnamedplus'
      end)

      vim.o.ignorecase = true -- Ignore case of searches
      vim.o.smartcase = true -- Don't ignorecase if Uppercase char present

      -- Open new slit panes to right and bottom
      vim.o.splitright = true
      vim.o.splitbelow = true

      -- Show invisible characters
      vim.o.list = true
      vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

      vim.o.inccommand = 'split' -- Show pane with substitutions

      vim.o.cursorline = true -- Highligh current line
      vim.o.scrolloff = 3 -- Start scrolling 3 lines before the horizontal window border

      vim.o.confirm = true -- Ask to save a file if there are changes
    '';

    # My configs for .config/nvim/init.vim. Takes precedence over the Lua config
    extraConfig = ''
      colorscheme catppuccin-macchiato "catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

      let mapleader=","

      set colorcolumn=80,100
      set title        " Show the filename in the window titlebar
      set nofoldenable " disable auto folding
      set autoindent   " Automatic indentation
      set smartindent  " Make it smart
      set autochdir    " Change current working dir to the file's dir


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

      autocmd FileType csv setlocal textwidth=0       " disable line wraps for csv
      autocmd FileType ledger setlocal ts=4 sts=4 sw=4 expandtab " use 4 spaces to indent ledger
      autocmd FileType markdown setlocal textwidth=79 " make text break lines at 79 chars
      autocmd FileType rst setlocal textwidth=79      " make text break lines at 79 chars
      autocmd FileType sh setlocal ts=4 sts=4 sw=4 expandtab " use 4 spaces to indent shell scripts
      autocmd FileType terraform setlocal sw=2 expandtab " use 2 spaces as indentation
      autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab foldmethod=indent " use 2 spaces to indent yaml
      autocmd FileType make setlocal noexpandtab

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
      let garden_wiki.path = '~/projects/vimwiki'
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
