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
		let bufname = bufname( "%" ) . " [Scratch]"
		let scratch_buffer = bufnr( bufname )

		if scratch_buffer == -1
			" It doesn't already exist. Create it.
			let scratch_buffer = bufnr( bufname, 1 )
			let parent_buffer = bufnr( "%" )

			silent execute "sbuffer" scratch_buffer

			" We've created a new buffer, so set some defaults.
			call setbufvar( scratch_buffer, "&number", 0 )
			call setbufvar( scratch_buffer, "&swapfile", 0 )
			call setbufvar( scratch_buffer, "&buftype", "nofile" )
			call setbufvar( scratch_buffer, "&bufhidden", "wipe" )
			call setbufvar( scratch_buffer, "scratchpad_parent", parent_buffer )

			" Close-the-window map.
			nnoremap <buffer> <silent> <LocalLeader>p :bw<CR>
			let leader = exists("g:maplocalleader") ? g:maplocalleader : "\\"
			silent call append(0, "# Use " . leader . "p to close this buffer.")
		else
			silent execute "sbuffer" scratch_buffer
		endif
	endif

	" Make the actual call.
	if exists("l:scratchpad_command")
		execute l:scratchpad_command
	else
		silent call append(line("$"), "Set up a scratchpad command!")
	endif

	let &switchbuf = switchbuf_before
endfunction
