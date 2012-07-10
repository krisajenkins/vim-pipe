nnoremap <silent> <LocalLeader>r :call <SID>Scratchpad()<CR>
nnoremap <LocalLeader>s :source %<CR>

function! s:Scratchpad() " {
	" Save local settings.
	let saved_unnamed_register = @@
	let switchbuf_before = &switchbuf
	set switchbuf=useopen

	" Lookup the scratchpad command, either from here or a parent.
	if exists("b:scratchpad_parent")
		let l:scratchpad_command = getbufvar( b:scratchpad_parent, 'scratchpad_command' )
		let l:parent_buffer = b:scratchpad_parent
	elseif exists("b:scratchpad_command")
		let l:scratchpad_command = b:scratchpad_command
		let l:parent_buffer = bufnr( "%" )
	endif

	" Create a new scratchpad, if necessary.
	if ! exists("b:scratchpad_parent")
		let bufname = bufname( "%" ) . " [Scratchpad]"
		let scratchpad_buffer = bufnr( bufname )

		if scratchpad_buffer == -1
			let scratchpad_buffer = bufnr( bufname, 1 )

			" Split & open.
			silent execute "sbuffer" scratchpad_buffer

			" Set some defaults.
			call setbufvar( scratchpad_buffer, "&swapfile", 0 )
			call setbufvar( scratchpad_buffer, "&buftype", "nofile" )
			call setbufvar( scratchpad_buffer, "&bufhidden", "wipe" )
			call setbufvar( scratchpad_buffer, "scratchpad_parent", l:parent_buffer )

			call setbufvar( scratchpad_buffer, "&filetype", getbufvar( l:parent_buffer, 'scratchpad_filetype' ) )

			" Close-the-window mapping.
			nnoremap <buffer> <silent> <LocalLeader>p :bw<CR>
		else
			silent execute "sbuffer" scratchpad_buffer
		endif

		let l:should_switchback = 1
	endif

	" Grab the contents of the parent buffer.
	let l:parent_contents = getbufline(l:parent_buffer, 0, "$")

	" Replace the scratchpad contents.
	execute ":%d _"
	call append(line('.'), l:parent_contents)

	" Make the actual call.
	if exists("l:scratchpad_command")
		silent execute ":%!" . l:scratchpad_command
	else
		silent call append(line("$"), "See :help scratchpad.txt for setup advice.")
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
