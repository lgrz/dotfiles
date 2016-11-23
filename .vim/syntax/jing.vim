" Vim syntax file
" Language: Jing

if exists("b:current_syntax")
  finish
endif

syn case match

syn keyword    jingDeclType       action fluent rel fun prolog

hi def link    jingDeclType       Type

syn keyword    jingStatement      citer conc interrupt iter ndet pconc pick search
syn keyword    jingConditional    if else
syn keyword    jingRepeat         while
syn keyword    jingFunction       procedure

hi def link    jingStatement      Statement
hi def link    jingConditional    Conditional
hi def link    jingRepeat         Repeat
hi def link    jingFunction       Function

syn keyword    jingConstants         true false
hi def link    jingConstants         Constant

syntax keyword     jingTodo              contained TODO FIXME XXX BUG
syntax cluster     jingCommentGroup      contains=jingTodo
syntax region      jingComment           start="/\*" end="\*/" contains=@jingCommentGroup,@Spell
syntax region      jingComment           start="//" end="$" contains=@jingCommentGroup,@Spell

syn match    jingDecimalInt "\<\d\+\>"

hi def link  jingDecimalInt    Integer
hi def link  Integer           Number

highlight default link jingComment           Comment
highlight default link jingTodo              Todo
