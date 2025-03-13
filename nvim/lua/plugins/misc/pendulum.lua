return {
  'ptdewey/pendulum-nvim',
  config = function()
    require('pendulum').setup {
      log_file = vim.fn.expand '$HOME/Documents/myUsageReport.csv',
      timeout_len = 300, -- Time before session is considered inactive (5 min)
      timer_len = 60, -- How often the session updates (1 min)
      gen_reports = true,
      top_n = 50,
      report_section_excludes = {
        -- 'branch', -- Hide `branch` section of the report
        -- Other options includes:
        -- "directory",
        -- "filetype",
        -- "file",
        -- "project",
      },
      report_excludes = {
        filetype = {
          'neo-tree', -- Exclude neo-tree filetype
        },
        file = {
          --'test.py', -- Exclude any test.py
          -- '.*.go', -- Exclude all Go files
        },
        project = {
          -- 'unknown_project', -- Exclude unknown (non-git) projects
        },
        directory = {},
        branch = {},
      },
    }
  end,
}
