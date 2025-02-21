return {
  --With Report Generation (Requires Go)
  'ptdewey/pendulum-nvim',
  config = function()
    require('pendulum').setup {
      log_file = vim.fn.expand '$HOME/Documents/my_custom_log.csv',
      timeout_len = 300, -- 5 minutes
      timer_len = 60, -- 1 minute
      gen_reports = true, -- Enable report generation (requires Go)
      top_n = 10, -- Include top 10 entries in the report
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
          -- This table controls what to be excluded from `filetype` section
          'neo-tree', -- Exclude neo-tree filetype
        },
        file = {
          -- This table controls what to be excluded from `file` section
          'test.py', -- Exclude any test.py
          '.*.go', -- Exclude all Go files
        },
        project = {
          -- This table controls what to be excluded from `project` section
          'unknown_project', -- Exclude unknown (non-git) projects
        },
        directory = {
          -- This table controls what to be excluded from `directory` section
        },
        branch = {
          -- This table controls what to be excluded from `branch` section
        },
      },
    }
  end,
}
