nnoremap <silent> <LocalLeader>r :call <SID>Scratchpad()<CR>
nnoremap <silent> <LocalLeader>s :source %<CR>

function! s:Scratchpad()
	let switchbuf_before = &switchbuf
	set switchbuf=useopen

	" Lookup the scratchpad command, either from here or a parent.
	if exists("b:scratchpad_parent")
		let l:scratchpad_command = getbufvar( b:scratchpad_parent, 'scratchpad_command' )
	elseif exists("b:scratchpad_command")
		let l:scratchpad_command = b:scratchpad_command
	endif

	if ! exists("b:scratchpad_parent")

		" Find or create a scratchpad.
		let bufname = bufname( "%" ) . " [Scratchpad]"
		let scratchpad_buffer = bufnr( bufname )

		if scratchpad_buffer == -1
			" It doesn't already exist. Create it.
			let scratchpad_buffer = bufnr( bufname, 1 )
			let parent_buffer = bufnr( "%" )

			silent execute "sbuffer" scratchpad_buffer

			" We've created a new buffer, so set some defaults.
			call setbufvar( scratchpad_buffer, "&number", 0 )
			call setbufvar( scratchpad_buffer, "&swapfile", 0 )
			call setbufvar( scratchpad_buffer, "&buftype", "nofile" )
			call setbufvar( scratchpad_buffer, "&bufhidden", "wipe" )
			call setbufvar( scratchpad_buffer, "scratchpad_parent", parent_buffer )

			" Close-the-window map.
			nnoremap <buffer> <silent> <LocalLeader>p :bw<CR>
			let leader = exists("g:maplocalleader") ? g:maplocalleader : "\\"
			silent call append(0, "# Use " . leader . "p to close this buffer.")
		else
			silent execute "sbuffer" scratchpad_buffer
		endif
	endif

	" Make the actual call.
	if exists("l:scratchpad_command")
		execute l:scratchpad_command
	else
		silent call append(line("$"), "Set up a scratchpad command using :let b:scratchpad_command='...'.")
	endif

	let &switchbuf = switchbuf_before
endfunction
