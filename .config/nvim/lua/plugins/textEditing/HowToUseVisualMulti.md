---

## 🔸 1. Word-Based Multi-Cursor Selection — `<C-n>`

### 🎯 Goal:

Select multiple occurrences of the same word and edit them together.

### 🧭 Steps:

* Place your cursor over a word (e.g., `count`).
* Press `<C-n>` to select it.
* Press `<C-n>` repeatedly to select additional matches.
* Press `i`, `c`, or `A` to start editing.

### 🧪 Example:

```cpp
int count = 0;
if (count < 5) {
    count++;
}
```

* Place the cursor on the first `count`.
* Press `<C-n>` → selects first `count`.
* Press `<C-n>` twice more → selects next 2.
* Press `i` and type `total` → all `count` become `total`.

---

## 🔸 2. Vertical Cursor Placement — `<C-Up>` / `<C-Down>`

### 🎯 Goal:

Create multiple vertically aligned cursors (like column editing).

### 🧭 Steps:

* Place your cursor at the top of the column.
* Press `<C-Down>` (or `<C-Up>`) to add cursors line-by-line.
* Press `i`, `A`, or `I` to begin editing.

### 🧪 Example:

```txt
name
name
name
```

* Cursor on the first `name`.
* Press `<C-Down>` two times.
* Press `A` and type `_edited`.

➡️ Becomes:

```txt
name_edited
name_edited
name_edited
```

---

## 🔸 3. Paragraph-Based Multi-Cursor — `cp`

### 🎯 Goal:

Select the entire paragraph and create multicursors on it.

### 🧭 Steps:

* Move your cursor **inside** a paragraph or block of text.
* Press `cp` to visually select the paragraph and activate multi-cursors on each line or word.
* Press `i`, `A`, etc., to edit them.

### 🧪 Example:

```cpp
int score = 0;
int lives = 3;
int level = 1;
```

* Cursor on `score`.
* Press `cp` → all 3 lines selected, with cursors.
* Press `I` and type `// `

➡️ Becomes:

```cpp
// int score = 0;
// int lives = 3;
// int level = 1;
```

---

## 🔸 4. Visual Selection + Search — `<M-s>` (Visual Mode)

### 🎯 Goal:

Create multi-cursors for **matching text** inside the selected region.

### 🧭 Steps:

* Visually select a word or phrase with `v` or `V`.
* Press `<M-s>` (Alt + S).
* All other matches of that selection in the buffer will get a cursor.

### 🧪 Example:

```cpp
int score = 0;
int highscore = 100;
if (score > highscore) {
```

* Select `score` with `viw`.
* Press `<M-s>`.

➡️ All `score` instances now have cursors — ready to rename or edit.

---

## 🔸 5. Global Search + Multi-Cursor — `<M-s>` (Normal Mode)

### 🎯 Goal:

Create cursors at **every match** of a search pattern in the file.

### 🧭 Steps:

* Press `<M-s>` in normal mode.
* Type the word or pattern (like `error`) and press `<Enter>`.
* Cursors appear on every match across the file.

### 🧪 Example:

```cpp
log_error("Failed to load");
...
log_error("Invalid user input");
```

* Press `<M-s>`.
* Enter `log_error` and press Enter.

➡️ Cursors appear on both `log_error` calls. Now press `rL` to replace with `log_critical`, etc.

---

## 🔸 6. Visual Block to Multi-Cursor — `<M-c>`

### 🎯 Goal:

Turn a **manual visual selection** into multicursors on the lines or block.

### 🧭 Steps:

* Select a block of text in **visual mode** (using `v`, `V`, or `<C-v>`).
* Press `<M-c>`.
* Cursors are created on each line in the selection.

### 🧪 Example:

```cpp
deleteUser();
deleteUser();
deleteUser();
```

* Visual-select all three lines with `Vjj`.
* Press `<M-c>`.
* Press `rA` to replace `deleteUser` with `archiveUser`.

➡️ Becomes:

```cpp
archiveUser();
archiveUser();
archiveUser();
```

---

## 🧠 Final Tip

At any time during multi-cursor editing:

* Press `Tab` → switch between **cursor** and **extend** mode.
* Use `q`, `Q` → to skip/remove cursors.
* Use motions (`w`, `b`, `e`) or commands (`r`, `~`, `ciw`, etc.) like regular Vim.

---
