return {
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'
      local mason_tool_installer = require 'mason-tool-installer'
      mason.setup {
        ui = {
          icons = {
            package_installed = '✓', -- Icon for installed packages
            package_pending = '➜', -- Icon for pending installations
            package_uninstalled = '✗', -- Icon for uninstalled packages
          },
        },
      }
      mason_lspconfig.setup {
        ensure_installed = {
          'clangd',
          'lua_ls',
          'pyright',
          'glsl_analyzer',
          'wgsl_analyzer',
          'yamlls',
          'marksman',
          'vimls',
        },
        automatic_installation = true,
      }
      mason_tool_installer.setup {
        ensure_installed = {
          'prettier',
          'stylua',
          'isort',
          'black',
          'pylint',
        },
      }
    end,
  },
}
