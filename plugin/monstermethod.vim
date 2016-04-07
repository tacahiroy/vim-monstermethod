" File: plugin/monstermethod.vim
" Description:
" Author: Takahiro Yoshihara <tacahiroy@gmail.com>
" License: Modified BSD License
" Copyright (c) 2015-2016, Takahiro Yoshihara

command! -nargs=0 MonsterMethodEnable call monstermethod#enable()
command! -nargs=0 MonsterMethodDisable call monstermethod#disable()
command! -nargs=0 MonsterMethodToggle call monstermethod#toggle()
