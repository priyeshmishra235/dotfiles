return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c',
          'cpp',
          'rust',
          'lua',
          'python',
          'glsl',
          'wgsl',
          'hlsl',
          'html',
          'css',
          'javascript',
          'typescript',
          'php',
          'go',
          'json',
          'json5',
          'toml',
          'yaml',
          'sql',
          'cmake',
          'make',
          'ninja',
          'bash',
          'markdown',
          'vim',
          'gitignore',
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        indent = {
          enable = true,
        },
      }
      require('nvim-treesitter.install').prefer_git = true
    end,
  },
}
