# debrief.vim
Show diffs while writing commit messages.

## Plugin Status
:no_entry: UNMAINTAINED

I like this workflow better than `git commit --verbose`, but the distinction
isn't worth a plugin. I'm no longer using this myself.

## Details
Whenever you start editing a commit message, a diff of your staged changes is
shown on the right. I know, mind blowing.

## Installation
**[vim-plug](https://github.com/junegunn/vim-plug)**
```vimscript
Plug 'PsychoLlama/debrief.vim'
```

**[vundle](https://github.com/VundleVim/Vundle.vim)**
```vimscript
Plugin 'PsychoLlama/debrief.vim'
```

**[pathogen](https://github.com/VundleVim/Vundle.vim)**
```sh
git clone --depth 1 https://github.com/PsychoLlama/debrief.vim.git ~/.vim/bundle/
```

## Documentation
For documentation on the programmatic API, check out `:help debrief`.
