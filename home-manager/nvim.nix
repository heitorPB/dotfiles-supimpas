# My neovim settings
{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    withPython3 = true; # I don't know if I need this, but it was the default
    withRuby = true; # I don't know if I need this, but it was the default

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
      let front_matter.front_matter.tags = []
      let g:zettel_options = [front_matter]
      " change default new filename to title.md
      let g:zettel_format = "%title"
      " use [[file|title]] for internal links
      let g:zettel_link_format = "[[%link|%title]]"
    '';

    initLua =
      /*
      lua
      */
      ''
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

        -- Open new split panes to right and bottom
        vim.o.splitright = true
        vim.o.splitbelow = true

        -- Show invisible characters
        vim.o.list = true
        vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

        vim.o.inccommand = 'split' -- Show pane with substitutions

        vim.o.cursorline = true -- Highlight current line
        vim.o.scrolloff = 3 -- Start scrolling 3 lines before the horizontal window border

        vim.o.confirm = true -- Ask to save a file if there are changes

        -- File type detection extras. Usefull for syntax highlighting via e.g. tree-sitter
        vim.filetype.add({
          pattern = {
            [".*/charts?/.*/templates/.*%.ya?ml"] = "helm",
            [".*/charts?/.*/values.ya?ml"] = "helm",
            [".*helmfile.*%.ya?ml"] = "helm",
            [".*%.sh"] = "bash",
            [".*%.service"] = "systemd"
          }
        })
      '';

    plugins = with pkgs.vimPlugins; [
      # Tree-sitter now compiles the parsers and stores in
      # `~/.local/share/nvim/site/`, added to impermanence
      {
        plugin = nvim-treesitter;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            -- The new nvim-treesitter (`main` branch) does not start
            -- automatically. This autocmd starts it and auto-installs the
            -- language parser based on the `filetype`.
            vim.api.nvim_create_autocmd({ 'Filetype' }, {
              callback = function(event)
                -- Make sure nvim-treesitter is available
                local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')
                if not ok then return end

                local parsers = require('nvim-treesitter.parsers')

                if not parsers[event.match] or not nvim_treesitter.install then return end

                local ft = vim.bo[event.buf].ft
                local lang = vim.treesitter.language.get_lang(ft)
                nvim_treesitter.install({ lang }):await(function(err)
                  if err then
                    vim.notify('Treesitter install error for ft: ' .. ft .. ' err: ' .. err)
                    return
                  end

                  pcall(vim.treesitter.start, event.buf)
                  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                  -- vim.wo.foldmethod = 'expr'
                  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                end)
              end,
            })
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
            -- Bash LSP
            vim.lsp.enable('bashls')

            -- Golang LSP
            vim.lsp.config('gopls', {
              settings = {
                gopls = {
                  analyses = {
                    -- fieldalignment = true, -- structs can use less memory if variables are aligned
                    unusedparams = true,
                    unusedvariable = true,
                  },
                  completeUnimported = true,
                  gofumpt = true,
                  staticcheck = true,
                  usePlaceholders = true,
                },
              },
            })
            vim.lsp.enable('gopls')

            -- Python LSP
            vim.lsp.enable('pyright')
            vim.lsp.config('ruff', {
              init_options = {
                settings = {
                  logLevel = 'debug'
                }
              }
            })
            vim.lsp.enable('ruff')

            -- Nix LSP
            vim.lsp.config('nil_ls', {
                autostart = true,
                capabilities = caps,
                cmd = { "nil" },
                settings = {
                    ["nil"] = {
                      formatting = { command = { "alejandra" }, },
                      nix = { flake = { autoArchive = true }, },
                    },
                },
            })
            vim.lsp.enable('nil_ls')

            vim.lsp.enable('terraformls') -- Official from HashiCorp
            vim.lsp.enable('tflint') -- TFLint, a Terraform linter and LSP

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
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
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

      # Debugging
      nvim-dap # Main plugin
      nvim-nio # Async IO, required for nvim-dap-ui
      {
        plugin = nvim-dap-ui;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local dap = require("dap")
            local dapui = require("dapui")

            vim.keymap.set('n', '<Leader>dc', function() dap.continue() end)
            vim.keymap.set('n', '<Leader>dn', function() dap.step_over() end) -- next
            vim.keymap.set('n', '<Leader>dsi', function() dap.step_into() end)
            vim.keymap.set('n', '<Leader>dso', function() dap.step_out() end)
            vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
            -- vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)
            -- vim.keymap.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
            vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
            vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
            vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
              require('dap.ui.widgets').hover()
            end)
            vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
              require('dap.ui.widgets').preview()
            end)
            vim.keymap.set('n', '<Leader>df', function()
              local widgets = require('dap.ui.widgets')
              widgets.centered_float(widgets.frames)
            end)
            vim.keymap.set('n', '<Leader>ds', function()
              local widgets = require('dap.ui.widgets')
              widgets.centered_float(widgets.scopes)
            end)

            -- DAP UI setup
            -- ------------

            dapui.setup()

            dap.listeners.before.attach.dapui_config = function()
              dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
              dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
              dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
              dapui.close()
            end

            vim.keymap.set('n', '<Leader>dt', function() dapui.toggle() end)
          '';
      }
      {
        plugin = nvim-dap-go;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("dap-go").setup()

            --[[
            -- Override the Go adapter so that "remote attach" configs connect to Docker/Delve
            dap.adapters.go = function(callback, config)
              -- If this is one of your Docker remote configs, act as a client
              if config.request == 'attach' and config.mode == 'remote' then
                callback({
                  type = 'server',
                  host = config.host or 'localhost',
                  port = config.port or 2345,
                })
              else
                -- Fallback: for other configs (e.g. local debugging), behave like a normal dlv adapter
                callback({
                  type = 'executable',
                  command = 'dlv',
                  args = { 'dap' },
                })
              end
            end
            --]]
          '';
      }
      {
        plugin = nvim-dap-python;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require('dap-python').setup('python3')
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
  };
}
