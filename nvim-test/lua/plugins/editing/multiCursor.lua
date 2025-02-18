return {
  'mg979/vim-visual-multi',
}
-- Basic usage:
--
-- - Select words with Ctrl-N (like Ctrl-D in Sublime Text/VS Code)
-- - Create cursors vertically with Ctrl-Down/Ctrl-Up
-- - Select one character at a time with Shift-Arrows
-- - Press n/N to get next/previous occurrence
-- - Press [/] to select next/previous cursor
-- - Press q to skip current and get next occurrence
-- - Press Q to remove current cursor/selection
-- - Start insert mode with i, a, I, A
--
-- Two main modes:
--
-- - In "cursor mode," commands work as they would in normal mode.
-- - In "extend mode," commands work as they would in visual mode.
--
-- - Press Tab to switch between «cursor» and «extend» mode.
--
-- Most Vim commands work as expected (motions, `r` to replace characters, `~` to change case, etc).
-- documentation: :help visual-multi
