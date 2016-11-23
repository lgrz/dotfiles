"" Load .vimrc.local if it exists
if filereadable('.vimrc.local')
    source .vimrc.local
    echom "vimrc.local read"
endif
