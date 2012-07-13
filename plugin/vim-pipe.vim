nnoremap <silent> <LocalLeader>r :call <SID>VimPipe()<CR>

function! s:VimPipe() " {
	" Save local settings.
	let saved_unnamed_register = @@
	let switchbuf_before = &switchbuf
	set switchbuf=useopen

	" Lookup the vimpipe command, either from here or a parent.
	if exists("b:vimpipe_parent")
		let l:vimpipe_command = getbufvar( b:vimpipe_parent, 'vimpipe_command' )
		let l:parent_buffer = b:vimpipe_parent
	else
		let l:parent_buffer = bufnr( "%" )

		if exists("b:vimpipe_command")
			let l:vimpipe_command = b:vimpipe_command
		endif
	endif

	" Create a new output buffer, if necessary.
	if ! exists("b:vimpipe_parent")
		let bufname = bufname( "%" ) . " [VimPipe]"
		let vimpipe_buffer = bufnr( bufname )

		if vimpipe_buffer == -1
			let vimpipe_buffer = bufnr( bufname, 1 )

			" Close-the-window mapping.
			execute "nnoremap \<buffer> \<silent> \<LocalLeader>p :bw " . vimpipe_buffer . "\<CR>"

			" Split & open.
			silent execute "sbuffer" vimpipe_buffer

			" Set some defaults.
			call setbufvar(vimpipe_buffer, "&swapfile", 0)
			call setbufvar(vimpipe_buffer, "&buftype", "nofile")
			call setbufvar(vimpipe_buffer, "&bufhidden", "wipe")
			call setbufvar(vimpipe_buffer, "vimpipe_parent", l:parent_buffer)

			call setbufvar(vimpipe_buffer, "&filetype", getbufvar(l:parent_buffer, 'vimpipe_filetype'))

			" Close-the-window mapping.
			nnoremap <buffer> <silent> <LocalLeader>p :bw<CR>
		else
			silent execute "sbuffer" vimpipe_buffer
		endif

		let l:should_switchback = 1
	endif

	" Grab the contents of the parent buffer.
	let l:parent_contents = getbufline(l:parent_buffer, 0, "$")

	" Replace the output buffer's contents.
	execute ":%d _"

	" Make the actual call.
	if exists("l:vimpipe_command")
		call append(line('.'), l:parent_contents)
		silent execute ":%!" . l:vimpipe_command
	else
		silent call append(line("$"), "See :help vim-pipe for setup advice.")
	endif

	" Add a tip.
	let leader = exists("g:maplocalleader") ? g:maplocalleader : "\\"
	silent call append(0, ["# Use " . leader . "p to close this buffer.", ""])

	" Go back to the last window.
	if exists("l:should_switchback")
		execute "normal! \<C-W>\<C-P>"
	endif

	" Restore local settings.
	let &switchbuf = switchbuf_before
	let @@ = saved_unnamed_register
endfunction " }

" vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
