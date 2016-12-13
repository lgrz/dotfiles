"" Load local .vimrc if it exists
if filereadable('.vimrc')
    source .vimrc
    echom "local .vimrc loaded"
endif
