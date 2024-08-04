# OneLeaf

A light colorscheme for Vim/NVIM.

![OneLeaf NVIM](https://github.com/jasen215/oneleaf.vim/raw/main/oneleaf.nvim.png)

![OneLeaf VIM](https://github.com/jasen215/oneleaf.vim/raw/main/oneleaf.vim.png)

## Features

- 16 colors
- 256 colors
- Supports Vim and Neovim

## Usage

## Installation

Install manually or use a package manager:

```viml
" vim-plug
Plug 'jasen215/oneleaf.vim'
" Vundle
Plugin 'jasen215/oneleaf.vim'
" Lazy
  {
    "jasen215/oneleaf.vim",
    lazy = false,
    priority = 1000,
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme oneleaf]])
    end,
  },
```

Once your plugin is installed you can set the color scheme in your `.vimrc` or `init.vim`

```viml
" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Theme
syntax enable
colorscheme oneleaf
```


<br><br>

---

© 2020 Released under [MIT License](https://raw.github.com/jacoborus/nanobar/master/LICENSE)
