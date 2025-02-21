return {
  {
    'tpope/vim-fugitive', -- Core Fugitive plugin (required)
  },
  --[[{
    'shumphrey/fugitive-gitlab.vim', -- GitLab extension for Fugitive
    dependencies = { 'tpope/vim-fugitive' },
    config = function()
      -- Configure GitLab domains
      vim.g.fugitive_gitlab_domains = { 'https://my.gitlab.com' } -- Change this to your GitLab instance

      -- If using SSH/HTTPS hybrid setup
      -- vim.g.fugitive_gitlab_domains = { ['my-ssh.gitlab.com'] = 'https://my.gitlab.com' }

      -- Set GitLab API keys
      vim.g.gitlab_api_keys = { ['gitlab.com'] = 'myaccesstoken' }

      -- If using multiple GitLab instances
      -- vim.g.gitlab_api_keys = { ['gitlab.com'] = 'mytoken1', ['my.gitlab.private'] = 'mytoken2' }
    end,
  },]]
  {
    'tpope/vim-rhubarb', -- GitHub extension for Fugitive
    dependencies = { 'tpope/vim-fugitive' },
    config = function()
      -- No extra config is needed; vim-rhubarb auto-detects GitHub remotes
    end,
  },
}
