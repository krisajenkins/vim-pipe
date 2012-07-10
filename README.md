What is this?
----

It's a work in progress. ;-)

Actually, it's sortof a REPL for things that don't have a REPL. If you're editing a file that will be piped to a command, this plugin can speed up your development hugely.

If your SQL files all get evaluated by Postgres, add this line to your vimrc:

	autocmd FileType sql :let b:scratchpad_command="psql <dbname>"

...then whenever you're editing an SQL file type <Leader>r to evaluate it and see the results in a temporary window.

Help
---

See :help scratchpad.txt for more.

Installation
----

* Install Pathogen.
* Clone this project into `~/.vim/bundle/`.
* Add this to your .vimrc file:

	    " You may already have these settings. Add them if not:
	    syntax on
	    filetype plugin

		" Add lines like this to your .vimrc file.
		autocmd FileType sql :let b:scratchpad_command="psql <dbname>"
		autocmd FileType sh  :let b:scratchpad_command="bash"
