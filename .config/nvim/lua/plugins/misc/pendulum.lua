return {
  'ptdewey/pendulum-nvim',
  config = function()
    require('pendulum').setup {
      log_file = vim.fn.expand '$HOME/Documents/my_custom_log.csv',
      timeout_len = 300,
      timer_len = 60,
      gen_reports = true,
      top_n = 50,
      report_section_excludes = {
        -- 'branch',"directory","filetype",
        -- "file","project",
      },
      report_excludes = {
        filetype = {},
        file = {},
        project = {},
        directory = {},
        branch = {},
      },
    }
  end,
}
