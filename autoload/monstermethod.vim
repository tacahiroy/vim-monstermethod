" File: autoload/monstermethod.vim
" Description:
" Author: Takahiro Yoshihara <tacahiroy@gmail.com>
" License: Modified BSD License
" Copyright (c) 2015, Takahiro Yoshihara

if get(g:, 'loaded_monstermethod', 0)
  finish
endif
let g:loaded_monstermethod = 1

let s:save_cpo = &cpo
set cpo&vim

let s:funcs = {}

function! s:has_ctrlp_funky()
  return !empty(globpath(&runtimepath,  'autoload/ctrlp/funky.vim'))
endfunction

function! s:has_filter(ft)
  let func = 'autoload/ctrlp/funky/ft/' . a:ft . '.vim'
  return !empty(globpath(&runtimepath, func))
endfunction

function! s:format(lnum, line)
  let v = ''
  if s:show_lnum
    let v .= a:lnum . ':'
  endif
  return v . a:line
endfunction

function! monstermethod#search()
  let bn = bufnr('%')
  let pos = getpos('.')

  let line = ''
  let lnum = 0

  try
    let fts = getbufvar(bn, '&filetype')
    for ft in split(fts, '\.')
      if s:has_filter(ft)
        let filters = ctrlp#funky#ft#{ft}#filters()
        for fil in filters
          " TODO: filter.offset needs to be referred
          if search(fil.pattern, 'bcW')
            let lnum = line('.') + get(fil, 'offset', 0)
            let line = getline(lnum)
            break
          endif
        endfor
        if !empty(line) | break | endif
      endif
    endfor
  finally
    call setpos('.', pos)
  endtry

  let line = substitute(line, '^[\t ]\+', '', '')

  if lnum > 0
    return s:format(lnum, line)
  else
    return ''
  endif
endfunction

" * GUARD
if !s:has_ctrlp_funky()
  echoerr 'ctrlp-funky not detected! Please make sure ctrlp-funky is installed.'
  finish
endif

" * OPTIONS
let s:show_lnum   = get(g:, 'monstermethod_show_line_number', 1)
let s:remove_type = get(g:, 'monstermethod_remove_type_name', 0)
" remove alike in args
let s:remove_args = get(g:, 'monstermethod_remove_args', 0)

let &cpo = s:save_cpo
unlet s:save_cpo
