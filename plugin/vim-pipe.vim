" =============================================================================
" File:          plugin/vim-pipe.vim
" Description:   VIM plugin to send a buffer through a command and instantly
"                see the output.
" Author:        Kris Jenkins <http://blog.jenkster.com/>
" License:       MIT (http://www.opensource.org/licenses/MIT)
" Website:       http://github.com/krisajenkins/vim-pipe
" Version:       1.1
" Copyright Notice:
"                Permission is hereby granted to use and distribute this code,
"                with or without modifications, provided that this copyright
"                notice is copied with it. Like anything else that's free,
"                vim-pipe is provided *as is* and comes with no warranty of
"                any kind, either expressed or implied. In no event will the
"                copyright holder be liable for any damamges resulting from
"                the use of this software.
" =============================================================================

" Finish if already loaded {{{1
if exists('g:loaded_vim_pipe')
  finish
endif
let g:loaded_vim_pipe = 1

function! s:SetGlobalOptDefault(opt, val) "{{{1
  if !exists('g:' . a:opt)
    let g:{a:opt} = a:val
  endif
endfunction

" Set Global Defaults {{{1
call s:SetGlobalOptDefault('vimpipe_invoke_map', '<LocalLeader>r')
call s:SetGlobalOptDefault('vimpipe_close_map', '<LocalLeader>p')
call s:SetGlobalOptDefault('vimpipe_silent', 0)

" Default configuration for Files {{{1
let s:filetype_configs = {
      \ 'ruby': {
      \   'command': 'ruby'
      \ },
      \ 'javascript': {
      \   'command': 'mocha <(cat)'
      \ },
      \ 'sql': {
      \   'command': 'psql mydatabase'
      \ },
      \ 'html': {
      \   'command': 'lynx -dump -stdin'
      \ },
      \ 'markdown': {
      \   'command': 'multimarkdown | lynx -dump -stdin'
      \ },
      \ 'mongoql': {
      \   'command': 'mongo',
      \   'filetype': 'javascript'
      \ }}

for [ftype, config] in items(s:filetype_configs)
  let g:vimpipe_{ftype}_command = config['command']
  if get(config, 'filetype', 0)
    let g:vimpipe_{ftype}_filetype = config['filetype']
  endif
endfor

function! VimPipe() "{{{1
  " Save local settings.
  let saved_unnamed_register = @@
  let switchbuf_before = &switchbuf
  let &switchbuf = 'useopen'

  " Lookup the parent buffer.
  if exists("b:vimpipe_parent")
    let l:parent_buffer = b:vimpipe_parent
    let l:parent_buffer_ft = getbufvar( b:vimpipe_parent, '&filetype' )
  else
    let l:parent_buffer = bufnr( "%" )
    let l:parent_buffer_ft = getbufvar( l:parent_buffer, '&filetype' )

    " Create a new output buffer, if necessary.
    let bufname = bufname( "%" ) . " [VimPipe]"
    let vimpipe_buffer = bufnr( bufname )

    if vimpipe_buffer == -1
      let vimpipe_buffer = bufnr( bufname, 1 )

      " Close-the-window mapping within vimpipe target window
      execute "nnoremap <buffer> <silent> " . g:vimpipe_close_map . " :<C-U>bw " . vimpipe_buffer . "<CR>"

      " Split & open.
      let split_command = "sbuffer " . vimpipe_buffer
      if &splitright | let split_command = "vert " . split_command | endif
      silent execute split_command

      " Set some defaults.
      let l:vimpipe_filetype = getbufvar(l:parent_buffer, 'vimpipe_filetype')
      " Loogup the vimpipe filetype from the global variable
      if empty(l:vimpipe_filetype) && exists('g:vimpipe_{l:parent_buffer_ft}_filetype')
        let l:vimpipe_filetype = g:vimpipe_{l:parent_buffer_ft}_filetype
      endif
      call setbufvar(vimpipe_buffer, "&swapfile", 0)
      call setbufvar(vimpipe_buffer, "&buftype", "nofile")
      call setbufvar(vimpipe_buffer, "&bufhidden", "wipe")
      call setbufvar(vimpipe_buffer, "vimpipe_parent", l:parent_buffer)
      call setbufvar(vimpipe_buffer, "&filetype", l:vimpipe_filetype)

      " Close-the-window mapping within vimpipe window.
      execute "nnoremap <buffer> <silent> " . g:vimpipe_close_map . " :bw<CR>"
    else
      silent execute "sbuffer" vimpipe_buffer
    endif

    let l:parent_was_active = 1
  endif

  if !g:vimpipe_silent
    " Display a "Running" message.
    silent! execute ":1,2d _"
    silent call append(0, ["# Running... ",""])
  endif

  redraw

  " Clear the buffer.
  execute ":%d _"

  " Lookup the vimpipe command from the parent.
  let l:vimpipe_command = getbufvar( b:vimpipe_parent, 'vimpipe_command' )
  " Lookup the vimpipe command from the global variable.
  if empty(l:vimpipe_command) && exists('g:vimpipe_{l:parent_buffer_ft}_command')
    let l:vimpipe_command = g:vimpipe_{l:parent_buffer_ft}_command
  endif

  " Call the pipe command, or give a hint about setting it up.
  if empty(l:vimpipe_command)
    silent call append(0, ["", "# See :help vim-pipe for setup advice."])
  else
    let l:parent_contents = getbufline(l:parent_buffer, 0, "$")
    call append(line('0'), l:parent_contents)

    let l:start = reltime()
    silent execute ":%!" . l:vimpipe_command

    let l:duration = reltimestr(reltime(start))
    if !g:vimpipe_silent
      silent call append(0, ["# Pipe command took:" . duration . "s", ""])
    endif
  endif

  if !g:vimpipe_silent
    " Add the how-to-close shortcut.
    silent call append(0, "# Use " . g:vimpipe_close_map . " to close this buffer.")
  endif

  " Go back to the last window.
  if exists("l:parent_was_active")
    wincmd p
  endif

  " Restore local settings.
  let &switchbuf = switchbuf_before
  let @@ = saved_unnamed_register
endfunction

" Define Mappings {{{1
execute "nnoremap <silent> " . g:vimpipe_invoke_map . " :call VimPipe()<CR>"

" Modeline {{{1
" vim: set foldlevel=1 foldmethod=marker:
