return {
  -- GLSL syntax highlighting
  {
    'tikhomirov/vim-glsl',
    ft = { "glsl", "vert", "frag", "geom", "comp" },
  },
  --doesnot work for glsl
  -- Live color preview inside shaders
  -- {
  --   'NvChad/nvim-colorizer.lua',
  --   event = "VeryLazy",
  --   opts = {
  --     filetypes = { "glsl", "vert", "frag", "geom", "comp" },
  --     user_default_options = {
  --       names = false,
  --       rgb_fn = true,
  --       hsl_fn = true,
  --       mode = "foreground",
  --     }
  --   },
  --   config = function(_, opts)
  --     require("colorizer").setup(opts.filetypes, opts.user_default_options)
  --   end
  -- }
}
