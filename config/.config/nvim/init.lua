--
-- Global configs
--

vim.o.syntax = off
vim.o.diffopt = 'filler,internal,algorithm:histogram,indent-heuristic' -- better diff
vim.wo.number = true -- show line numbers
vim.wo.wrap = false -- dont wrap lines
vim.o.updatetime = 250 -- reduce updatetime for CursorHold event (added becaues of nvim-lspconfig diagnostics on hover)
vim.wo.relativenumber = true -- relative line numbers

-- Indentation
vim.o.expandtab = true -- expand tabs into spaces
vim.o.tabstop = 2 -- number of spaces in a tab (how tabs looks)
vim.o.shiftwidth = 2 -- number of spaces for indent (how many spaces each tab will add)

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true -- do not ignore if search pattern has CAPS

-- Show tabs and trailing spaces
vim.o.list = true
vim.o.listchars = 'tab:>·,trail:■'

-- Highlight current line
vim.api.nvim_create_autocmd('WinEnter', {
  callback = function() vim.wo.cursorline = true end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  callback = function() vim.wo.cursorline = false end,
})
vim.wo.cursorline = true

-- Store undo history in files on `undodir`, to remember after vim closes
vim.o.undofile = true
vim.fn.system(string.format('find "%s" -type f -mtime 365 -execdir rm -- "{}" \\;', vim.o.undodir)) -- remove older than 1 year

--
-- General key maps
--

vim.g.mapleader = ','
vim.keymap.set('n', '<Space>', ',', { remap = true, desc = '<Space> as alternative leader' })
vim.keymap.set('n', '<leader>h', ':noh<CR>', { desc = 'Hide highlgihts' })
vim.keymap.set('n', '<leader>d', function()
  -- ugh, workaround for https://github.com/folke/trouble.nvim/issues/134
  -- no need to call is_open() as close() will also do it.
  require('trouble').close()
  vim.cmd(':bd')
end, { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>w', ':set wrap!<CR>', { desc = 'Toggle line wrap' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Repeated jj is same as <Esc> to exist insert mode' })

-- upgrade all plugins and dependencies
function UpgradeEverything(close_after)
  -- Install, clean and update Lazy plugins
  require('lazy').sync({ wait=true })
  require('lazy.view').view:close()

  -- Update Mason registry, then all packages
  local registry = require('mason-registry')
  registry.refresh(function ()
    require('mason.ui').open()
    local packages_to_install = registry.get_installed_packages()
    local index = 1

    local function install_next_package()
      if index <= #packages_to_install then
        local pkg = packages_to_install[index]
        pkg:install({}, function()
          index = index + 1
          vim.schedule(install_next_package)
        end)
      else
        if close_after == true then
          vim.cmd('qa')
        else
          require('mason.ui.instance').window.close()
        end
      end
    end

    install_next_package()
  end)
end

vim.keymap.set('n', '<leader>U', UpgradeEverything, { desc = 'Upgrade plugins' })

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

  -- Simple greeter / startup screen
  {
    'goolord/alpha-nvim',
    config = function()
      local poke_file = vim.fn.expand('$HOME/.config/nvim/.pokemon')
      local layout = {
        { type = 'padding', val = 10 },
        {
          type = 'text',
          val = {
            [[                                  __]],
            [[     ___     ___    ___   __  __ /\_\    ___ ___]],
            [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
            [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
            [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
            [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
          },
          opts = {
            position = 'center',
            hl = 'Type',
          },
        },
        { type = 'padding', val = 5 },
      }

      if vim.fn.filereadable(poke_file) == 1 then
        local width = tonumber(vim.fn.system(string.format([[cat %s | sed 's/\x1b\[[0-9;]*m//g' | wc -L -m | awk '{print $2}']], poke_file)))
        local height = tonumber(vim.fn.system(string.format('wc -l < %s', poke_file)))
        table.insert(layout, {
          type = 'terminal',
          command = string.format('cat %s', poke_file),
          width = width,
          height = height,
          opts = {},
        })
      end

      require('alpha').setup({ layout = layout })
      require('alpha.term')

      -- Generate new Pokemon asynchronously for next time, with a delay so current have time to render
      vim.defer_fn(function()
        vim.fn.jobstart(
          string.format('%s > %s', vim.fn.expand('$OH_MY_GIL_SH/scripts/plugins/pokemon-colorscripts/src/pokemon-colorscripts.py -r 1'), poke_file),
          { detach = true }
        )
      end, 1000)
    end
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
      { dir = vim.fn.expand('$OH_MY_GIL_SH/scripts/themes/base16-themes/output/base16-vim-airline') },
      { 'ryanoasis/vim-devicons' },
      {
        'edkolev/tmuxline.vim', -- Generate a tmux theme based on the same them used on airline
        config = function()
          vim.g['airline#extensions#tmuxline#enabled'] = 1
          vim.g['airline#extensions#tmuxline#snapshot_file'] = vim.fn.expand('$HOME') .. '/.tmux/tmux-statusline-colors.conf'
          vim.g.tmuxline_preset = {
            a       = '#S',
            win     = '#I #W',
            cwin    = '#I #W',
            x       = '#H 󰒍 ',
            y       = "#(uptime | awk '{print $3}' | sed 's/,//g')  ",
            z       = '%R  #($HOME/.tmux/plugins/tmux-continuum/scripts/continuum_save.sh)',
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
    'junegunn/fzf',
    build = function() vim.fn['fzf#install']() end,
  },
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
    config = function()
      vim.api.nvim_create_user_command('FZFMru', function()
        local function mru_files()
          -- Get v:oldfiles and filter out unwanted entries (only updated on vim close)
          local oldfiles = vim.tbl_filter(function(val)
            return not string.match(val, 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/')
          end, vim.fn.copy(vim.v.oldfiles))

          -- Get list of all buffers, with non-empty names, including closed
          local buffers = vim.tbl_map(function(val)
            return vim.fn.bufname(val)
          end, vim.tbl_filter(function(val)
            return vim.fn.bufname(val) ~= ""
          end, vim.fn.range(1, vim.fn.bufnr('$'))))

          return vim.list_extend(buffers, oldfiles)
        end

        -- Run fzf using the retrieved files list
        vim.fn['fzf#run'](
          vim.fn['fzf#vim#with_preview'](
            vim.fn['fzf#wrap']({
              source = mru_files(),
              sink = 'edit',
              options = '--multi --extended --no-sort --keep-right',
            })
          )
        )
      end, {})

      vim.api.nvim_create_user_command('FZFModified', function()
        local cmd = [[bash -c "(git diff --relative --name-only $(git branch -rl '*/HEAD' | grep -o '[^ ]\+$') 2>/dev/null ; git status --short 2>/dev/null | cut -c4-) | xargs -n 1 -I {} find {} -type f 2>/dev/null | sort | uniq"]]
        local files = vim.fn.systemlist(cmd)

        if #files == 0 then
          vim.notify('No modified files found', vim.log.levels.INFO)
          return
        end

        vim.fn['fzf#run'](
          vim.fn['fzf#vim#with_preview'](
            vim.fn['fzf#wrap']({
              source = files,
              sink = 'edit',
              options = '--multi --extended --keep-right',
            })
          )
        )
      end, {})

      vim.env.BAT_STYLE = 'header-filename,numbers'

      vim.g.fzf_layout = { window = { width = 0.9, height = 0.9 } }

      vim.g.fzf_vim = {
        preview_window = { 'up,50%', 'ctrl-/' },
        buffers_jump = 1,
        grep_multi_line = 2,
        buffers_options = '--keep-right',
      }

      vim.keymap.set('', '<C-p>', ':Files<CR>', { desc = 'Search files' })
      vim.keymap.set('', '<leader>p', ':FZFMru<CR>', { desc = 'MRU Files' })
      vim.keymap.set('', '<leader>o', ':Buffers<CR>', { desc = 'Show buffers' })
      vim.keymap.set('', '<leader>l', ':FZFModified<CR>', { desc = 'Modified files' })
      vim.keymap.set('n', '<leader>r', function()
        local last_search = vim.fn.getreg('/')
        vim.cmd.Rg(last_search)
      end, { desc = 'Rg from last search' })
    end,
  },

  -- Simple file explorer
  {
    'echasnovski/mini.files',
    version = '*',
    config = function()
      local files = require('mini.files')
      files.setup()
      vim.keymap.set('n', '<C-n>', files.open, { desc = 'File browser' })
      vim.keymap.set('n', '<leader>n', function() files.open(vim.api.nvim_buf_get_name(0)) end, { desc = 'File browser from this path' })
    end,
  },

  -- Change cwd automatically when it finds some specific files
  {
    'airblade/vim-rooter',
    config = function()
      vim.g.rooter_patterns = { 'package.json', 'deno.json*', '=node_modules', '.git' }
      vim.g.rooter_manual_only = 1
      vim.keymap.set('n', '<leader>gr', ':Rooter<CR>', { desc = 'Change to project root' })
    end,
  },

  -- Navigate code easier (modern alternative to EasyMotion)
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      require('hop').setup()
      vim.keymap.set('n', 's', ':HopChar2MW<CR>', { desc = 'Hop+2 chars' })
    end,
  },

  -- Allow you to navigate seamlessly between vim and tmux splits
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },

  -- Allow pasting directly into Neovim without needing to run `:set paste!` before
  -- For iTerm2, enable: "Terminal may enable paste bracketing"
  { 'ConradIrwin/vim-bracketed-paste' },

  -- Show changed lines from git
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup({
        watch_gitdir = {
          enable = false -- don't watch repo, it can be super slow on huge repos!
        },
        current_line_blame = true,
        current_line_blame_formatter = '<abbrev_sha>: <summary> (<author_time:%Y-%m-%d> <author>)',
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
          end)
        end
      })

      vim.keymap.set('n', '<leader>b', function()
        vim.print(vim.b.gitsigns_blame_line)
        for hash in string.gmatch(vim.b.gitsigns_blame_line, '(%w+):') do
          vim.fn.system('pbcopy -', hash)
          break
        end
      end, { desc = 'Copy git line blame hash' })
    end,
  },

  -- Super fast CSS colorizer
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },

  -- Highlighting words similar to where the cursor is
  { 'RRethy/vim-illuminate' },

  -- Comment lines easily with: gc/gcc
  {
    'echasnovski/mini.comment',
    version = '*',
    config = function()
      require('mini.comment').setup({
          mappings = {
          comment = '<leader>c',
          comment_line = '<leader>cc',
          comment_visual = '<leader>c',
          textobject = '<leader>c',
        },
      })
    end,
  },

  -- Easily surround / wrap selection with something like parenthesis or quotes.
  {
    'echasnovski/mini.surround',
    version = '*',
    config = function ()
      require('mini.surround').setup({
        mappings = {
          add = '<leader>sa', -- Add surrounding in Normal and Visual modes
          delete = '<leader>sd', -- Delete surrounding
          find = '<leader>sf', -- Find surrounding (to the right)
          find_left = '<leader>sF', -- Find surrounding (to the left)
          highlight = '<leader>sh', -- Highlight surrounding
          replace = '<leader>sr', -- Replace surrounding
          update_n_lines = '<leader>sn', -- Update `n_lines`
        },
      })
    end,
  },

  -- Auto close pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  },

  -- Auto close and auto rename html tags based on treesitter
  {
    'windwp/nvim-ts-autotag',
    config = true
  },

  -- Indent lines
  {
    'echasnovski/mini.indentscope',
    version = false,
    config = function()
      local indentscope = require('mini.indentscope')
      indentscope.setup({
        draw = {
          animation = indentscope.gen_animation.none(),
        },
        symbol = '┊',
      })
    end
  },

  -- Show keymaps
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    version = '2.*',
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' }, -- nice collection of snippets
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  -- Use Treesitter for better syntax highlight
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require('nvim-treesitter.configs')

      configs.setup({
        ensure_installed = {
          'lua', 'vim', 'vimdoc', 'perl', 'bash', 'markdown',
          'python', 'ruby', 'sql', 'yaml',
          'html', 'css', 'javascript', 'typescript', 'tsx', 'vue', 'json',
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        -- indent = { enable = true },
      })
    end
  },

  -- Code outline window
  {
    'stevearc/aerial.nvim',
    dependencies = {
      -- 'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require('aerial').setup({
        manage_folds = true,
      })
      vim.keymap.set('n', '<leader>aw', '<cmd>AerialToggle!<CR>', { desc = 'Toggle code outline window' })
      vim.keymap.set('n', '<leader>as', '<cmd>call aerial#fzf()<CR>', { desc = 'FZF find symbols' })
    end,
  },

  --
  -- Language Server Protocol (LSP)
  --

  -- Install and manage LSP servers from Neovim
  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    opts = {}
  },

  -- Makes it easier to integrate mason.nvim with nvim-lspconfig
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'ts_ls',
          'denols',
          'html',
          'cssls',
          'vue_ls',
          'lua_ls',
          'eslint',
          'stylelint_lsp',
        },
      })
    end,
  },

  -- Configs for Neovim LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
    },
    config = function()
      -- Configs: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      -- Extends defaults from: https://github.com/neovim/nvim-lspconfig/tree/master/lsp

      -- Javascript / Typescript
      vim.lsp.config('ts_ls', {
        single_file_support = false
      })

      -- Deno
      vim.lsp.config('denols', {
        workspace_required = true,
        root_markers = { 'deno.json', 'deno.jsonc' },
      })

      vim.g.markdown_fenced_languages = {
        'ts=typescript'
      }

      -- Vue.js
      vim.lsp.config('vue_ls', {
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
      vim.lsp.config('lua_ls', {
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

      -- ESlint
      vim.lsp.config('eslint', {
        settings = {
          workingDirectory = { mode = 'auto' }, -- helps find the eslintrc when it's placed in a subfolder instead of the cwd root
          codeActionOnSave = { enable = true, mode = 'problems' },
        },
        on_attach = function(client, buffer)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = buffer,
            callback = function(event)
              local eslint = function(formatter) return formatter.name == 'eslint' end
              vim.lsp.buf.format({ async = false, filter = eslint })
            end,
          })
        end,
      })

      -- Error on hover
      vim.api.nvim_create_autocmd('CursorHold', {
        buffer = bufnr,
        callback = function()
          local opts = {
            focusable = false,
            close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          }
          vim.diagnostic.open_float(nil, opts)
        end
      })

      -- Keymaps
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Find definition' })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Find declaration' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover symbol info' })
      vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
    end,
  },

  -- Show errors/warnings from LSP
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        icons = false,
      })
      vim.keymap.set('n', '<leader>xx', function() require('trouble').open() end, { desc = 'Trouble diagnostics' })
      vim.keymap.set('n', '<leader>xw', function() require('trouble').open('workspace_diagnostics') end, { desc = 'Trouble workspace diagnostics' })
      vim.keymap.set('n', '<leader>xd', function() require('trouble').open('document_diagnostics') end, { desc = 'Trouble document diagnostics' })
    end,
  },

  -- Better TypeScript errors
  {
    'dmmulroy/ts-error-translator.nvim',
    config = function()
      require('ts-error-translator').setup()
    end,
  },

  -- LSP Completion
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    -- dependencies = 'rafamadriz/friendly-snippets',

    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'super-tab',
        ['<Esc>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },

      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        }
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'normal'
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
    opts_extend = { 'sources.default' }
  },
})
