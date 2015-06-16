" Finish if already loaded {{{1
if exists('g:loaded_vimpipe')
	finish
endif
let g:loaded_vimpipe = 1

function! s:SetGlobalOptDefault(opt, val) "{{{1
  if !exists('g:' . a:opt)
    let g:{a:opt} = a:val
  endif
endfunction

" Set Global Defaults {{{1
call s:SetGlobalOptDefault('vimpipe_invoke_map', '<LocalLeader>r')
call s:SetGlobalOptDefault('vimpipe_close_map', '<LocalLeader>p')
call s:SetGlobalOptDefault('vimpipe_silent', 0)

function! VimPipe() range "{{{1
	" Save local settings.
	let saved_unnamed_register = @@
	let switchbuf_before = &switchbuf
	set switchbuf=useopen

	" Lookup the parent buffer.
	if exists("b:vimpipe_parent")
		let l:parent_buffer = b:vimpipe_parent
	else
		let l:parent_buffer = bufnr( "%" )
	endif

	" Create a new output buffer, if necessary.
	if ! exists("b:vimpipe_parent")
		let bufname = bufname( "%" ) . " [VimPipe]"
		let vimpipe_buffer = bufnr( bufname )

		if vimpipe_buffer == -1
			let vimpipe_buffer = bufnr( bufname, 1 )

			" Close-the-window mapping within vimpipe target window
			execute "nnoremap <buffer> <silent> " . g:vimpipe_close_map . " :<C-U>bw " . vimpipe_buffer . "<CR>"

			" Split & open.
			let split_command = "sbuffer " . vimpipe_buffer
			if &splitright
				let split_command = "vert " . split_command
			endif
			silent execute split_command

			" Set some defaults.
			call setbufvar(vimpipe_buffer, "&swapfile", 0)
			call setbufvar(vimpipe_buffer, "&buftype", "nofile")
			call setbufvar(vimpipe_buffer, "&bufhidden", "wipe")
			call setbufvar(vimpipe_buffer, "vimpipe_parent", l:parent_buffer)
			call setbufvar(vimpipe_buffer, "&filetype", getbufvar(l:parent_buffer, 'vimpipe_filetype'))

			" Close-the-window mapping within vimpipe window.
			execute "nnoremap <buffer> <silent> " . g:vimpipe_close_map . " :<C-U>bw<CR>"
		else
			silent execute "sbuffer" vimpipe_buffer
		endif

		let l:parent_was_active = 1
	endif

	if g:vimpipe_silent != 1
		" Display a "Running" message.
		silent! execute ":1,2d _"
		silent call append(0, ["# Running... ",""])
	endif

	redraw

	" Clear the buffer.
	execute ":%d _"

	" Lookup the vimpipe command from the parent.
	let l:vimpipe_command = getbufvar( b:vimpipe_parent, 'vimpipe_command' )

	" Call the pipe command, or give a hint about setting it up.
	if empty(l:vimpipe_command)
		silent call append(0, ["", "# See :help vim-pipe for setup advice."])
	else
		let l:parent_contents = getbufline(l:parent_buffer, a:firstline, a:lastline)
		call append(line('0'), l:parent_contents)

		let l:start = reltime()
		silent execute ":%!" . l:vimpipe_command

		let l:duration = reltimestr(reltime(start))
		if g:vimpipe_silent != 1
			silent call append(0, ["# Pipe command took:" . duration . "s", ""])
		endif
	endif

	if g:vimpipe_silent != 1
		" Add the how-to-close shortcut.
		silent call append(0, "# Use " . g:vimpipe_close_map . " to close this buffer.")
	endif

	" Go back to the last window.
	if exists("l:parent_was_active")
		execute "normal! \<C-W>\<C-P>"
	endif

	" Restore local settings.
	let &switchbuf = switchbuf_before
	let @@ = saved_unnamed_register
endfunction

" Define Mappings {{{1
execute "nnoremap <silent> " . g:vimpipe_invoke_map . " :%call VimPipe()<CR>"
" Modeline {{{1
" vim: set foldlevel=1 foldmethod=marker:
