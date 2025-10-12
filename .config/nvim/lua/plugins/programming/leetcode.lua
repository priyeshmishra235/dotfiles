return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    arg = "leetcode.nvim",

    lang = "cpp",

    cn = {
      enabled = false,
      translator = true,
      translate_problems = true,
    },

    storage = {
      home = vim.fn.stdpath("data") .. "/leetcode",
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },

    plugins = {
      non_standalone = true,
    },

    logging = true,

    injector = {
      ["cpp"] = {
        imports = function()
          return { "#include <bits/stdc++.h>", "using namespace std;" }
        end,
        after = "int main() {}",
      },
    },

    cache = {
      update_interval = 60 * 60 * 24 * 7,
    },

    editor = {
      reset_previous_code = true,
      fold_imports = true,
    },

    console = {
      open_on_runcode = true,

      dir = "row",

      size = {
        width = "90%",
        height = "75%",
      },

      result = {
        size = "60%",
      },

      testcase = {
        virt_text = true,

        size = "40%",
      },
    },

    description = {
      position = "left",

      width = "40%",

      show_stats = true,
    },

    picker = { provider = nil },

    hooks = {
      ["enter"] = {},

      ["question_enter"] = {},

      ["leave"] = {},
    },

    keys = {
      toggle = { "q" },
      confirm = { "<CR>" },

      reset_testcases = "r",
      use_testcase = "U",
      focus_testcases = "H",
      focus_result = "L",
    },

    theme = {},

    image_support = false,
  },
}
