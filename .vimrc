set nocompatible
filetype off
syntax on

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'mitsuhiko/vim-jinja'
call vundle#end()
filetype plugin indent on

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Airline setup
set laststatus=2
let g:airline_theme = 'hybrid'
" let g:airline_powerline_fonts = 1
let g:airline_detect_paste = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep = '⮁'
let g:airline_right_alt_sep = '⮃'
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
let g:airline_section_c = '%{getcwd()} ⮁ %f'

function! AirlineInit()
	let g:airline_section_a = airline#section#create(['mode'])
endfunction
autocmd VimEnter * call AirlineInit()

" GitGutter setup
let g:gitgutter_sign_column_always = 1

" YCM setup
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_key_list_select_completion = ['<TAB>', ]

" FZF setup
set rtp+=/usr/local/Cellar/fzf/0.13.3

" Color scheme
set t_Co=256
set background=dark
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

" Cursor line
set cursorline

set iminsert=0
set imsearch=0
set incsearch
set ic
set hls
set number
set iskeyword=@,48-57,_,192-255
set expandtab
set smarttab
set ts=4
set backspace=2 " make backspace work like most other apps
set backspace=eol,start
set nowrap
set ls=2
set enc=utf-8
set scrolloff=10
set shiftwidth=4
set expandtab

" Commands
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
