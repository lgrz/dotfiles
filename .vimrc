
filetype plugin indent on
set number
set cursorline
set encoding=utf-8
set nocompatible
set ruler
set nowrap
set clipboard=unnamed
set history=10000
set showcmd
set backspace=indent,eol,start
set cmdheight=2
set relativenumber
"set colorcolumn=80

" ignore case when completing file names and direcorties
set wildignorecase

" Enable matchit plugin
source $VIMRUNTIME/macros/matchit.vim
" Enable man.vim plugin
runtime ftplugin/man.vim

set scrolloff=5   ""Number of screen lines to keep above and below the cursor
set scrolljump=-5 "" Number of lines to scroll when the cursor gets off the screen

"" Soft tabs, 4 spaces
set expandtab
set tabstop=4
set shiftwidth=4

"" Color
syntax on
set background=dark
colorscheme Tomorrow-Night

set incsearch
set hlsearch

let mapleader=","

" Insert blank line above/below, and move the cursor over
nnoremap <silent> [<space> :pu!=''<cr>:']+1<cr>
nnoremap <silent> ]<space> :pu=''<cr>:'[-1<cr>

"" What to do when the return key breaks on your keyboard
"" Remeber to use <C-v> to insert an `'`
" nnoremap ' :nohlsearch<cr>
" noremap! ' <cr>

"" When the t key breaks...
" inoremap <c-e> t


""
"" Save with CTRL-s
""
"" Requires 'stty -ixon' to work in some Terminals
""
" noremap <silent> <c-s> :update<cr>
" vnoremap <silent> <c-s> <c-c>:update<cr>
" inoremap <silent> <c-s> <c-o>:update<cr>

"
" Toggle spell check on current buffer
nnoremap <leader>; :setlocal spell!<cr>

"
" Toggle invisible characters
nnoremap <leader>l :set list!<cr>
" Set custom tabstop and eol symbols
set listchars=tab:┊\ ,eol:¬

""
"" Arrow keys are not allowed
""
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>

""
"" Netrw: quick open
""
noremap <silent> <f8> :Explore<cr>
noremap <silent> <leader><f4> :vs <bar> :Explore<cr>

""
"" Netrw: See 'netrw-p'
""
let g:netrw_preview = 1
" let g:netrw_liststyle = 3
let g:netrw_winsize = 30

"" TeX
let g:tex_indent_items = 1

augroup vimrcFileSettings
    " Clear all commands from this group
    autocmd!
    " Restore cursor on file read
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

    " text
    autocmd FileType text,md,tex setlocal textwidth=78
    " ruby, html
    autocmd FileType ruby,html,erb setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    " python
    autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    " go
    autocmd BufRead,BufNewFile *.go set filetype=go
    " rust
    autocmd BufRead,BufNewFile *.rs set filetype=rust
    " java
    autocmd FileType java setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    " cxx
    autocmd FileType cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd BufRead,BufNewFile *.hpp set filetype=cpp
    " jing
    autocmd BufRead,BufNewFile *.jing set filetype=jing
    " R
    autocmd FileType r setlocal keywordprg=Rscript\ -e\ \'?<cword>\'
    " tex, bib
    autocmd BufRead,BufNewFile *.tex set filetype=tex
    autocmd FileType tex setlocal textwidth=80
    autocmd FileType tex,bib map <buffer> <leader>g :!mupdf $HOME/bibdex/files/<cword>.pdf &<cr>
    autocmd FileType tex,bib setlocal iskeyword+=+
    autocmd FileType tex setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType bib setlocal tabstop=1 softtabstop=1 shiftwidth=1 expandtab
augroup END

""
"" Indent the start of a line. Else do completion.
""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

"" Disable default titlecase mapping
let g:titlecase_map_keys = 0
"" Add our own mappings for titlecase
nmap <leader>gt <Plug>Titlecase
vmap <leader>gt <Plug>Titlecase
nmap <leader>gT <Plug>TitlecaseLine

""
"" Backup and swap files
""

set backupdir=~/.vim/_backup/    " where to put backup files.
set directory=~/.vim/_temp/      " where to put swap files.

"
" Key Maps
"
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <Esc>

" Clear the search buffer when hitting return
nnoremap <cr> :nohlsearch<cr>
" Restore original `<cr>` when in a quickfix buffer
autocmd BufReadPost quickfix nnoremap <buffer> <cr> <cr>
autocmd CmdwinEnter * nnoremap <cr> <cr>
" Quick commit for WIP
map <leader>gw :!git add . && git commit -m 'wip'<cr>
" Clang format
map <leader>k :pyf /usr/share/clang/clang-format-6.0/clang-format.py<cr>
imap <leader>k <c-o>:pyf /usr/share/clang/clang-format-6.0/clang-format.py<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE (thanks Gary Bernhardt)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <Leader>n :call RenameFile()<cr>

"" vim-move - map escape sequences to alt combinations
"" http://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim
let c='a'
while c <= 'z'
    exec "set <A-".c.">=\e".c
    exec "imap \e".c." <A-".c.">"
    let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=50

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Selecta Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! SelectaFile(path)
  call SelectaCommand("find " . a:path . "/* -type f", "", ":e")
endfunction

nnoremap <leader>f :call SelectaFile(".")<cr>
nnoremap <leader>gs :call SelectaFile("src")<cr>

function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction
nnoremap <c-g> :call SelectaIdentifier()<cr>

:command! InsDate .!date '+\%d/\%m/\%y'
:command! InsDateStampUTC .!date -u '+\%Y-\%m-\%d \%T'

" :silent vert botright help quickfix
" :silent vert botright help cscope
