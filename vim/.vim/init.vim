" enter the current millenim
set nocompatible


" FINDING FILES:

" Search down into subfolders
" Provides tab-completion for all file-realted tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Set tabstop
set tabstop=4
set shiftwidth=4
set expandtab

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer


" TAG JUMPIN:

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .
set tags=./tags,tags,./.git/tags;

" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack


" Show the cursor position all the time
set ruler
" Show line number
set nu
" Set relative line number, it is useful in command such as num-j/k
set relativenumber
" Always show the status line at the bottom, even if you only have one window
" open.
set laststatus=2
" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Switch syntax highlighting on, when the terminal hash colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
    set t_Co=8
    set t_Sb=^[[4%dm
    set t_Sf=^[[3%dm
endif

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
" inoremap <Left>  <ESC>:echoe "Use h"<CR>
" inoremap <Right> <ESC>:echoe "Use l"<CR>
" inoremap <Up>    <ESC>:echoe "Use k"<CR>
" inoremap <Down>  <ESC>:echoe "Use j"<CR>
