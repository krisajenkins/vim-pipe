nnoremap <silent> <LocalLeader>r :call <SID>Scratchpad()<CR>
nnoremap <silent> <LocalLeader>s :source %<CR>

function! s:Scratchpad()
	let switchbuf_before = &switchbuf
	set switchbuf=useopen

	let current_buffer = bufnr( "%" )

	" Check - is this a scratch already?
	if exists("b:scratchpad_for")
		"echom "I am a Scratchpad for " b:scratchpad_for
	else
		" Find or create a scratchpad.
		let bufname = bufname( "%" ) . " - Scratch"
		let scratch_buffer = bufnr( bufname )

		if scratch_buffer == -1
			let scratch_buffer = bufnr( bufname, 1 )

			silent execute "sbuffer" scratch_buffer

			" Set default options.
			setlocal nonumber
			setlocal noswapfile
			setlocal buftype=nofile
			setlocal bufhidden=wipe

			let b:scratchpad_for = current_buffer

			nnoremap <buffer> <silent> <LocalLeader>p :bw<CR>
			let leader = exists("g:maplocalleader") ? g:maplocalleader : "\\"
			silent call append(0, "# Use " . leader . "p to close this buffer!")
		else
			silent execute "sbuffer" scratch_buffer
		endif
	endif

	let &switchbuf = switchbuf_before
endfunction
