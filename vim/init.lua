--
-- Global configs
--

vim.o.syntax = false
vim.o.diffopt = 'filler,internal,algorithm:histogram,indent-heuristic' -- better diff
vim.o.undofile = true -- store undo history in files on `undodir`, to remember after vim closes
vim.wo.number = true -- show line numbers

-- Indentation
vim.o.expandtab = true -- expand tabs into spaces
vim.o.tabstop = 2 -- number of spaces in a tab (how tabs looks)
vim.o.shiftwidth = 2 -- number of spaces for indent (how many spaces each tab will add)

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true -- do not ignore if search pattern has CAPS

-- Show tabs and trailing spaces
vim.o.list = true
vim.o.listchars = 'tab:>·,trail:·'

-- Highlight current line
vim.api.nvim_create_autocmd('WinEnter', {
  callback = function() vim.wo.cursorline = true end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  callback = function() vim.wo.cursorline = false end,
})
vim.wo.cursorline = true

-- Remove undo history older than 1 year
vim.fn.system(string.format('find "%s" -type f -mtime 365 -execdir rm -- "{}" \\;', vim.o.undodir))

--
-- General key maps
--

vim.g.mapleader = ','
vim.keymap.set('n', '<Space>', ',', { remap = true }) -- <Space> as alternative leader
vim.keymap.set('n', '<leader>h', ':noh<CR>') -- remove highlgihts from search
vim.keymap.set('n', '<leader>d', ':bd<CR>') -- delete buffer
vim.keymap.set('v', '<leader>y', '"+y') -- yank to system clipboard
vim.keymap.set('i', 'jj', '<Esc>') -- repeated jj is same as <Esc> to exist insert mode 

--
-- Plugins
--

-- Install lazy.nvim if not available
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Colorscheme / Theme
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      vim.o.background = 'dark'
      vim.cmd([[colorscheme gruvbox]])
    end,
  },

  -- Adds file type icons to Vim plugins, with any font patched from "Nerd Fonts"
  {
    'ryanoasis/vim-devicons',
    config = function()
      vim.g.WebDevIconsUnicodeDecorateFileNodesPatternSymbols = {
        ['.*\\.test\\.js$'] = '󰚔',
        ['.*\\.test\\.ts$'] = '󰚔',
        ['.*\\.spec\\.js$'] = '󰚔',
        ['.*\\.spec\\.ts$'] = '󰚔',
      }
    end,
  },

  -- Airline
  {
    'vim-airline/vim-airline',
    dependencies = {
      { dir = '$OH_MY_GIL_SH/scripts/themes/base16-themes/output/base16-vim-airline' },
      {
        'edkolev/tmuxline.vim', -- Generate a tmux theme based on the same them used on airline
        config = function()
          vim.g['airline#extensions#tmuxline#enabled'] = 1
          vim.g['airline#extensions#tmuxline#snapshot_file'] = vim.fn.expand('$OH_MY_GIL_SH') .. '/scripts/tools/assets/tmux-statusline-colors.conf'
          vim.g.tmuxline_preset = {
            a       = '#W',
            win     = '#I #W',
            cwin    = '#I #W',
            x       = '#H \\uf98c',
            y       = "#(uptime | awk '{print $3}' | sed 's/,//g') \\uFa51",
            z       = '%R \\ue385 ',
            options = { ['status-justify'] = 'left' }
          }
        end,
      },
    },
    config = function()
      vim.g.airline_theme = 'base16_gruvbox_dark_medium'
      vim.g.airline_powerline_fonts = 1
      vim.g['airline#extensions#whitespace#enabled'] = 0 -- disable whitespace detection
      vim.g['airline#parts#ffenc#skip_expected_string'] = 'utf-8[unix]' -- only show encoding that isn't utf-8[unix]

      vim.g['airline#extensions#tabline#enabled'] = 1
      vim.g['airline#extensions#tabline#show_close_button'] = 0
      vim.g['airline#extensions#tabline#show_splits'] = 0 -- don't show splits as tabs
      vim.g['airline#extensions#tabline#show_tab_type'] = 0 -- don't show tab type (e.g. [buffers]/[tabs])
      vim.g['airline#extensions#tabline#formatter'] = 'unique_tail_improved' -- optmize tab name on given space
    end,
  },

  -- fzf
  {
    'junegunn/fzf.vim',
    dependencies = {
      {
        'junegunn/fzf',
        build = function() vim.fn['fzf#install']() end,
      },
    },
    config = function()
      vim.keymap.set('', '<C-p>', ':Files<CR>')
      vim.keymap.set('', '<leader>p', ':History<CR>')
      vim.keymap.set('', '<leader>o', ':Buffers<CR>')
    end,
  },

  -- Navigate code easier (modern alternative to EasyMotion)
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      require('hop').setup()
      vim.keymap.set('n', 's', ':HopChar2MW<CR>')
    end,
  },

  -- Allow you to navigate seamlessly between vim and tmux splits
  { 'christoomey/vim-tmux-navigator' },

  -- Allow pasting directly into Neovim without needing to run `:set paste!` before
  { 'ConradIrwin/vim-bracketed-paste' },

  -- Super fast CSS colorizer
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },

  -- Use Treesitter for better syntax highlight
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function ()
      local configs = require('nvim-treesitter.configs')

      configs.setup({
        ensure_installed = {
          'lua', 'vim', 'vimdoc', 'perl', 'bash', 'markdown',
          'python', 'ruby', 'sql', 'yaml',
          'html', 'css', 'javascript', 'typescript', 'vue', 'json',
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  --
  -- Language Server Protocol (LSP)
  --

  -- Install and manage LSP servers from Neovim
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = function()
      require('mason').setup()
    end,
  },

  -- Makes it easier to integrate mason.nvim with nvim-lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        -- Automatically install the following servers, with Mason.
        -- List from: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
        ensure_installed = {
          'tsserver',
          'html',
          'cssls',
          'vuels',
          'lua_ls',
        },
      })
    end,
  },

  -- Configs for Neovim LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp'
    },
    config = function()
      local config = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Languages, from:
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

      -- Javascript / Typescript
      config.tsserver.setup({
        capabilities = capabilities,
      })

      -- HTML
      config.html.setup({
        capabilities = capabilities,
      })

      -- CSS
      config.cssls.setup({
        capabilities = capabilities,
      })

      -- Vue.js
      config.vuels.setup({
        capabilities = capabilities,
        init_options = {
          config = {
            vetur = {
              ignoreProjectWarning = true, -- don't complain when there's no project config
              validation = {
                interpolation = false, -- don't check template interpolation, it seem to break vue2, will check again with vue3
              },
            },
          },
        },
      })

      -- Lua
      config.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' }, -- Neovim uses LuaJIT
            diagnostics = { globals = {'vim'} },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true), -- Make the server aware of Neovim runtime files
              checkThirdParty = false, -- silence "Do you need to configure your work environment as XXX?" messages
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Keymaps
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover)
      vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float)
    end,
  },

  -- Support for additional LSP capabilities that Neovim doesn't by default
  { 'hrsh7th/cmp-nvim-lsp' },

  -- LSP Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'onsails/lspkind.nvim' }, -- vscode-like icons
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      cmp.setup({
        mapping = {
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),

          ['<Tab>'] = function(fallback)
            if not cmp.select_next_item() then
              if vim.bo.buftype ~= 'prompt' and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end,

          ['<S-Tab>'] = function(fallback)
            if not cmp.select_prev_item() then
              if vim.bo.buftype ~= 'prompt' and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end,
        },

        formatting = {
          format = lspkind.cmp_format({ -- add the nice icons
            menu = { -- show where the autocomplete item came from, after the icons (LSP, snippet, etc)
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
            },
          }),
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        })
      })
    end,
  },
})
