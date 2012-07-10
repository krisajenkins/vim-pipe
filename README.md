# Scratchpad

## Overview

Do you do this?

1. Edit the file.
1. Save the file.
1. Switch to a different terminal window.
1. Run something that uses the file.
1. Switch back.
1. Repeat, repeat, repeat...

_This plugin will save you time._

It's useful for developing SQL queries, markdown-checking, and anything that
needs to pass through a shell command while you develop.

## Detail

You associate a shell command with your file, something that will run against
the file's contents. If you're editing an SQL query, that command might be
`psql mydatabase`, for example.

Having done that, `<Leader>r` will run the current buffer against that
command and show you the results. You no longer need to
save-switch-execute-switch, which makes life faster and easier.

## Installation

* Install Pathogen.
* Clone this project into `~/.vim/bundle/`.
* Add this to your `.vimrc` file:

```vimscript
" You may already have these settings. Add them if not:
syntax on
filetype plugin

" Set the b:scratchpad_command variable for your buffer.
" The easiest way is to add an autocommand based on FileType.
autocmd FileType sql			:let b:scratchpad_command="psql <dbname>"
autocmd FileType markdown		:let b:scratchpad_command="multimarkdown"
```

## Help

See :help scratchpad.txt for more.
