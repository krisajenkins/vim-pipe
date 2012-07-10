Overview
----

Do you do this?

	# Edit the file.
	# Save the file.
	# Switch to a different terminal window.
	# Run something that uses the file.
	# Switch back.
	# Repeat, repeat, repeat...

This plugin will save you time.

Detail
----

You associate a shell command with your file, something that will run against
the file's contents. If you're editing an SQL query, that command might be
`psql mydatabase`, for example.

Having done that, `<Leader>r` will run the current buffer against that
command and show you the results. You no longer need to
save-switch-execute-switch, which makes life faster and easier.

Installation
----

* Install Pathogen.
* Clone this project into `~/.vim/bundle/`.
* Add this to your .vimrc file:

	" You may already have these settings. Add them if not:
	syntax on
	filetype plugin
	
	" Set the b:scratchpad_command variable for your buffer. The easiest way is to add an autocommand based on FileType.
	autocmd FileType sql			:let b:scratchpad_command="psql mydatabase"
	autocmd FileType sh				:let b:scratchpad_command="bash"

Help
---

See :help scratchpad.txt for more.
