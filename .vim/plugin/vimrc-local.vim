"" Don't try to load ~/.vimrc
if getcwd() == expand('~')
    finish
endif
"" Load local .vimrc if it exists
if filereadable('.vimrc')
    source .vimrc
    autocmd VimEnter * echom "local .vimrc loaded"
endif
