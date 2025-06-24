return {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
  opts = {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = -30,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = 'vertical',
    shell = vim.o.shell,
    auto_scroll = true,
    float_opts = {
      border = 'curved',
      winblend = 3,
      title_pos = 'center',
    },
    winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end,
    },
    responsiveness = {
      horizontal_breakpoint = 135,
    },
  },

  config = function(_, opts)
    require('toggleterm').setup(opts)

    -- Terminal keymaps (applied to all terminal buffers)
    function _G.set_terminal_keymaps()
      local keymap_opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], keymap_opts)
      vim.keymap.set('t', 'kj', [[<C-\><C-n>]], keymap_opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], keymap_opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], keymap_opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], keymap_opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], keymap_opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], keymap_opts)
    end

    vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

    local Terminal = require('toggleterm.terminal').Terminal

    local float_term = Terminal:new {
      direction = "float",
      hidden = true,
      close_on_exit = false,
      float_opts = { border = "curved" }
    }

    local function get_project_root()
      local markers = { "CMakeLists.txt", "compile_commands.json", "Makefile", "package.json" }

      local filepath = vim.api.nvim_buf_get_name(0)
      local path = vim.fs.dirname(filepath)

      local found = nil

      -- Start walking upward until we hit root or find a root marker
      while path and path ~= "/" do
        for _, marker in ipairs(markers) do
          local candidate = path .. "/" .. marker
          if vim.fn.filereadable(candidate) == 1 or vim.fn.isdirectory(candidate) == 1 then
            found = path -- don't return early; keep going up
          end
        end
        path = vim.fs.dirname(path)
      end

      return found or vim.loop.cwd()
    end

    function _PROJECT_ROOT_TERM()
      local root = get_project_root()
      local term = Terminal:new({
        dir = root,
        direction = "vertical",
        close_on_exit = false,
        hidden = true,
      })
      term:toggle()
    end

    function _PROJECT_TERM()
      local file_dir = vim.fn.expand("%:p:h")
      local term = Terminal:new({
        dir = file_dir,
        direction = "vertical",
        close_on_exit = false,
        hidden = true,
      })
      term:toggle()
    end

    -- Toggle Functions
    function _FLOAT_TERM() float_term:toggle() end

    -----------------------------------------------------------
    -- Keymaps for Named Terminals
    -----------------------------------------------------------
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle default terminal" })
    map("n", "<leader>tf", _FLOAT_TERM, { desc = "Toggle floating terminal" })
    map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
    map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
    map("n", "<leader>tc", _PROJECT_TERM, { desc = "Terminal (cwd of file)" })
    map("n", "<leader>tr", _PROJECT_ROOT_TERM, { desc = "Terminal at project root" })
  end,
}
