return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'antosha417/nvim-lsp-file-operations', config = true },
      { 'folke/neodev.nvim',                   opts = {} },
      'saghen/blink.cmp',
    },

    config = function()
      local lspconfig = require("lspconfig")

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lsp_defaults = lspconfig.util.default_config
      lsp_defaults.capabilities = vim.tbl_deep_extend('force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities(),
        require('blink.cmp').get_lsp_capabilities())

      -- Diagnostic Keymaps
      vim.keymap.set('n', '<space>d', vim.diagnostic.open_float,
        { noremap = true, silent = true, desc = 'Open Diagnostic Window' })
      vim.keymap.set('n', '<space><left>', function() vim.diagnostic.jump { count = -vim.v.count1 } end,
        { noremap = true, silent = true, desc = 'Previous Diagnostic' })
      vim.keymap.set('n', '<space><right>', function() vim.diagnostic.jump { count = vim.v.count1 } end,
        { noremap = true, silent = true, desc = 'Next Diagnostic' })
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist,
        { noremap = true, silent = true, desc = 'Send Diagnostic to Locallist' })
      vim.keymap.set('n', 'gK', function()
        local new_config = not vim.diagnostic.config().virtual_lines
        vim.diagnostic.config { virtual_lines = new_config }
      end, { noremap = true, silent = true, desc = 'Toggle diagnostic virtual_lines' })

      -- lsp attach keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.diagnostic.enable(true, { bufnr = ev.buf })
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or 'n', lhs, rhs, { buffer = ev.buf, desc = desc })
          end

          map('K', function() vim.lsp.buf.hover { border = 'single' } end, 'Hover')
          map('gra', vim.lsp.buf.code_action, 'Code Action', { 'n', 'v' })
          map('grn', vim.lsp.buf.rename, 'Rename')
          map('grr', vim.lsp.buf.references, 'References')
          map('grd', vim.lsp.buf.definition, 'Go to Definition')
          map('grD', vim.lsp.buf.declaration, 'Go to Declaration')
          map('gri', vim.lsp.buf.implementation, 'Go to Implementation')
          map('grf', function() vim.lsp.buf.format { async = true } end, 'Formatting')
          map('grk', function() vim.lsp.buf.signature_help { border = 'single' } end, 'Signature Help')
          map('grs', vim.lsp.buf.document_symbol, 'Document Symbols')
          map('grt', vim.lsp.buf.type_definition, 'Type Definition')
          map('grwa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
          map('grwr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
          map('grwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'List Workspace Folders')

          -- show inlay hints
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.inlayHintProvider then
            pcall(function()
              if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                vim.lsp.inlay_hint.enable(true, ev.buf)
              end
            end)
          else
            vim.lsp.inlay_hint.enable(false)
          end
        end,
      })

      -- Toggle Inlay Hints
      vim.keymap.set('n', '<Space>ih', function()
        if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable and vim.lsp.inlay_hint.is_enabled then
          local current = vim.lsp.inlay_hint.is_enabled()
          vim.lsp.inlay_hint.enable(not current)
        end
      end, { desc = 'Toggle Inlay Hints' })

      local signs = {
        [vim.diagnostic.severity.ERROR] = ' ',
        [vim.diagnostic.severity.WARN]  = ' ',
        [vim.diagnostic.severity.HINT]  = '󰌶 ',
        [vim.diagnostic.severity.INFO]  = ' ',
      }

      vim.diagnostic.config({
        signs = { text = signs },
        virtual_text = {
          prefix = '',
          spacing = 4,
          format = function(d)
            return string.format('%s %s',
              d.code and ('[' .. d.code .. ']') or '',
              d.message)
          end,
        },
        underline = true,
        update_in_insert = true,
        severity_sort = true,
        float = {
          border = 'single',
          source = 'always',
        },
      })

      lspconfig.clangd.setup({
        keys = {
          { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        root_dir = lspconfig.util.root_pattern(
          "compile_flags.txt", "compile_commands.json", "CMakeLists.txt",
          "Makefile", "configure.ac", "configure.in", "config.h.in",
          "meson.build", "meson_options.txt", "build.ninja"
        ),
        capabilities = {
          offsetEncoding = { "utf-16" },
          textDocument = {
            completion = {
              editsNearCursor = true,
            },
          },
        },
        cmd = {
          "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed",
          "--function-arg-placeholders=true", "--inlay-hints=true",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        single_file_support = true,
      })

      require('lspconfig').glsl_analyzer.setup({
        filetypes = { "glsl", "vert", "frag", "comp", "geom" },
        root_dir = require("lspconfig.util").root_pattern(".git", "*.glsl", "*.vert", "*.frag"),
      })
      require('lspconfig').wgsl_analyzer.setup({
        cmd = { "/home/priyeshmishra/.cargo/bin/wgsl-analyzer" },
        filetypes = { "wgsl" },
        root_dir = require("lspconfig.util").root_pattern("*.wgsl", ".git"),
        settings = {},
      })
      -- Lua
      local lspconfig = require("lspconfig")

      -- 🔹 Setup correct Lua runtime paths
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      -- 🔹 Setup the LSP
      lspconfig.lua_ls.setup {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            return
          end
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
              path = runtime_path,
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              },
            },
          })
          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = runtime_path,
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,
  },
}
