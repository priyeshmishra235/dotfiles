return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufWritePre', 'BufNewFile', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'antosha417/nvim-lsp-file-operations', config = true },
      { 'folke/neodev.nvim', opts = {} },
      { 'saghen/blink.cmp' },
    },
    config = function()
      -- ╭───────────╮
      -- │ LSPCONFIG │
      -- ╰───────────╯
      local lspconfig = require 'lspconfig'

      -- ╭──────────────────╮
      -- │ LSP CAPABILITIES │
      -- ╰──────────────────╯
      local lsp_defaults = lspconfig.util.default_config
      lsp_defaults.capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())
      lsp_defaults.capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities, require('blink.cmp').get_lsp_capabilities())

      -- ╭───────────────────╮
      -- │ WINBAR WITH NAVIC │
      -- ╰───────────────────╯
      -- local navic = require 'nvim-navic'

      -- ╭─────────────────────────────────────────────────────────╮
      -- │                   DIAGNOSTIC KAYMAPS                    │
      -- ╰─────────────────────────────────────────────────────────╯
      local opts = function(desc)
        return { noremap = true, silent = true, desc = desc }
      end

      vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, opts 'Open Diagnostic Window')
      vim.keymap.set('n', '<space><left>', function()
        vim.diagnostic.jump { count = -vim.v.count1 }
      end, opts 'Previous Diagnostic')
      vim.keymap.set('n', '<space><right>', function()
        vim.diagnostic.jump { count = vim.v.count1 }
      end, opts 'Next Diagnostic')
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts 'Send Diagnostic to Locallist')
      vim.keymap.set('n', 'gK', function()
        local new_config = not vim.diagnostic.config().virtual_lines
        vim.diagnostic.config { virtual_lines = new_config }
      end, { desc = 'Toggle diagnostic virtual_lines' })

      -- ╭───────────────────────╮
      -- │ LSPATTACH AUTOCOMMAND │
      -- ╰───────────────────────╯
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- ╭─────────╮
          -- │ KEYMAPS │
          -- ╰─────────╯
          local bufopts = function(desc)
            return { buffer = ev.buf, desc = desc }
          end
          -- All lsp keymaps starts with gr expept K.
          -- Default lsp keymaps. Setting the keymaps again, only to change the description.
          vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover { border = 'single' }
          end, bufopts 'Hover')
          vim.keymap.set({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, bufopts 'LSP Code Action')
          vim.keymap.set('n', 'grn', vim.lsp.buf.rename, bufopts 'LSP Rename')
          vim.keymap.set('n', 'grr', vim.lsp.buf.references, bufopts 'LSP References')
          -- Custom lsp keymaps.
          vim.keymap.set('n', 'grd', vim.lsp.buf.definition, bufopts 'LSP Go to Definition')
          vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, bufopts 'LSP Go to Declaration')
          vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, bufopts 'LSP Go to Implementation')
          vim.keymap.set('n', 'grf', function()
            vim.lsp.buf.format { async = true }
          end, bufopts 'LSP Formatting')
          vim.keymap.set('n', 'grk', function()
            vim.lsp.buf.signature_help { border = 'single' }
          end, bufopts 'LSP Singature Help')
          vim.keymap.set('n', 'grs', vim.lsp.buf.document_symbol, bufopts 'LSP Document Symbols')
          vim.keymap.set('n', 'grt', vim.lsp.buf.type_definition, bufopts 'LSP Type Definition')
          vim.keymap.set('n', 'grwa', vim.lsp.buf.add_workspace_folder, bufopts 'LSP Add Workspace Folder')
          vim.keymap.set('n', 'grwr', vim.lsp.buf.remove_workspace_folder, bufopts 'LSP Remove Workspace Folder')
          vim.keymap.set('n', 'grwl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts 'LSP List Workspace Folder')

          -- Get client
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- ╭─────────────╮
          -- │ INLAY HINTS │
          -- ╰─────────────╯
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          else
            vim.lsp.inlay_hint.enable(false)
          end

          -- ╭────────────╮
          -- │ NVIM-NAVIC │
          -- ╰────────────╯
          -- if client and client.server_capabilities.documentSymbolProvider then
          --   vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
          --   navic.attach(client, ev.buf)
          -- end

          -- ╭──────────╮
          -- │ TINYMIST │
          -- ╰──────────╯
          if client and client.name == 'tinymist' then
            -- Pin main file user command
            vim.api.nvim_create_user_command('PinMain', function()
              client:exec_cmd({
                command = 'tinymist.pinMain',
                arguments = { vim.api.nvim_buf_get_name(0) },
              }, { bufnr = ev.buf })
            end, {})
            -- Unpin main file user command
            vim.api.nvim_create_user_command('UnpinMain', function()
              client:exec_cmd({ command = 'tinymist.pinMain', arguments = { nil } }, { bufnr = ev.buf })
            end, {})
          end
        end,
      })

      -- ╭────────────────────╮
      -- │ TOGGLE INLAY HINTS │
      -- ╰────────────────────╯
      if vim.lsp.inlay_hint then
        vim.keymap.set('n', '<Space>ih', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = 'Toggle Inlay Hints' })
      end

      -- ╭─────────────────────────────────────────╮
      -- │ DISABLE LSP INLINE DIAGNOSTICS MESSAGES │
      -- ╰─────────────────────────────────────────╯
      -- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      --     virtual_text = false,
      -- })

      -- ╭───────────────────╮
      -- │ DIAGNOSTIC CONFIG │
      -- ╰───────────────────╯
      vim.diagnostic.config {
        virtual_text = {
          prefix = '', -- Could be '●', '▎', │, 'x', '■', , 
        },
        jump = {
          float = true,
        },
        float = { border = 'single' },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
            [vim.diagnostic.severity.INFO] = ' ',
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          },
        },
      }

      --  ╭──────────────────────────────────────────────────────────╮
      --  │                         SERVERS                          │
      --  ╰──────────────────────────────────────────────────────────╯

      -- ╭────────────╮
      -- │    C++     │
      -- ╰────────────╯
      lspconfig.clangd.setup {

        capabilities = {
          offsetEncoding = { 'utf-8', 'utf-16' },
          textDocument = {
            completion = {
              editsNearCursor = true,
            },
          },
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        single_file_support = true,
      }
      -- ╭────────────╮
      -- │ LUA SERVER │
      -- ╰────────────╯
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')
      lspconfig.lua_ls.setup {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file("", true)
            },
          })
          client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
        end,
        settings = {
          Lua = {},
        },
      }

      -- ╭───────────────╮
      -- │ PYTHON SERVER │
      -- ╰───────────────╯
      lspconfig.ruff.setup {}

      -- ╭─────────────╮
      -- │ JSON SERVER │
      -- ╰─────────────╯
      lspconfig.jsonls.setup {
        filetypes = { 'json', 'jsonc' },
        init_options = {
          provideFormatter = true,
        },
      }

      -- ╭─────────────╮
      -- │ RUST SERVER │
      -- ╰─────────────╯
      lspconfig.rust_analyzer.setup {}
    end,
  },
  -- {
  --   'jose-elias-alvarez/null-ls.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     local null_ls = require 'null-ls'
  --     null_ls.setup {
  --       sources = {
  --         null_ls.builtins.formatting.clang_format,
  --         null_ls.builtins.formatting.rustfmt,
  --         null_ls.builtins.formatting.stylua,
  --         null_ls.builtins.formatting.black,
  --         null_ls.builtins.formatting.prettier,
  --         null_ls.builtins.formatting.shfmt,
  --         null_ls.builtins.formatting.sqlfluff,
  --
  --         null_ls.builtins.diagnostics.cpplint,
  --         null_ls.builtins.diagnostics.flake8,
  --         null_ls.builtins.diagnostics.eslint_d,
  --         null_ls.builtins.diagnostics.phpstan,
  --         null_ls.builtins.diagnostics.golangci_lint,
  --         null_ls.builtins.diagnostics.jsonlint,
  --         null_ls.builtins.diagnostics.sqlfluff,
  --         null_ls.builtins.diagnostics.shellcheck,
  --         null_ls.builtins.diagnostics.markdownlint,
  --       },
  --     }
  --
  --     vim.api.nvim_create_autocmd('BufWritePre', {
  --       callback = function()
  --         vim.lsp.buf.format { async = false }
  --       end,
  --     })
  --   end,
  -- },
}
