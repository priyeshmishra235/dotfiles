return {
  event = 'CmdlineEnter',
  lazy = true,
  'Eandrju/cellular-automaton.nvim',
  vim.keymap.set('n', '<leader>gr', '<cmd>CellularAutomaton make_it_rain<CR>'),
  vim.keymap.set('n', '<leader>gl', '<cmd>CellularAutomaton game_of_life<CR>'),
  --You can close animation window with one of: q/<Esc>/<CR>
}
