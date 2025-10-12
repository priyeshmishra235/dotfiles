## 1. Scrolling Downwards
- **CTRL-E** → Scroll window `[count]` lines down (text moves up).
- **CTRL-D** → Scroll *Down* `[count]` lines (default: half screen, moves cursor).
- **CTRL-F / <PageDown> / <S-Down>** → Scroll forward `[count]` pages (full screen).

---

## 2. Scrolling Upwards
- **CTRL-Y** → Scroll window `[count]` lines up (text moves down).
- **CTRL-U** → Scroll *Up* `[count]` lines (default: half screen, moves cursor).
- **CTRL-B / <PageUp> / <S-Up>** → Scroll backward `[count]` pages (full screen).
- **z^** → Redraw with line just above window at bottom. With `[count]`, similar to `z<CR>`.

---

## 3. Scrolling Relative to Cursor
- **z<CR> / zt** → Redraw, put cursor line (or `[count]` line) at **top**.
- **z{height}<CR>** → Resize window to `{height}` lines.
- **z. / zz** → Redraw, put cursor line (or `[count]` line) at **center**.
- **z- / zb** → Redraw, put cursor line (or `[count]` line) at **bottom**.

---

## 4. Scrolling Horizontally (wrap must be off)
- **zl / z<Right>** → Scroll `[count]` chars right.
- **zh / z<Left>** → Scroll `[count]` chars left.
- **zL** → Scroll half screenwidth right.
- **zH** → Scroll half screenwidth left.
- **zs** → Scroll so cursor is at **left edge** of screen.
- **ze** → Scroll so cursor is at **right edge** of screen.

---

## Mnemonics
- **E** → *Extra lines* (small down).
- **Y** → Yank upwards (small up).
- **D/U** → Down / Up (half screen).
- **F/B** → Forwards / Backwards (full screen).
- **z** → Reposition/redraw around cursor.
