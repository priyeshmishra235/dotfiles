# Dotfiles

This repository contains the configuration (dotfiles) for my personal system setup an managed using [GNU Stow](https://www.gnu.org/software/stow/).

---

## Requirements

- **Git**
  ```
  sudo pacman -S git

- **GNU Stow**
  ```
  sudo pacman -S stow

---

## Installation

Clone the repository into your `$HOME` directory:

```bash
git clone git@github.com/priyeshmishra235/dotfiles.git
cd dotfiles
```

Then use **GNU Stow** to create symlinks for the dotfiles:

```bash
stow .
```
If you want to overwrite existing then use

```bash
stow . --adopt
```

---
