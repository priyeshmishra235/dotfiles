return {
  --<leader>p - image preview for file under cursor
  'adelarsq/image_preview.nvim',
  event = 'VeryLazy',
  config = function()
    require('image_preview').setup {
      --To use on neo-tree.nvim it's necessary to add a command on the setup
      require('neo-tree').setup {
        filesystem = {
          window = {
            mappings = {
              ['<leader>p'] = 'image_wezterm', -- " or another map
            },
          },
          commands = {
            image_wezterm = function(state)
              local node = state.tree:get_node()
              if node.type == 'file' then
                require('image_preview').PreviewImage(node.path)
              end
            end,
          },
        },
      },
    }
  end,
}
