# Vim Pipe

## Overview

Do you do this?

```
        hack <---------- alt-tab <---------- react
          |                                    |
+-------------------+                +-------------------+
| code code         |                | result result     |
| code              |                | result            |
|                   |                |                   |
|                   |                |                   |
|                   |                |                   |
|                   |                |                   |
|                   |                |                   |
+-------------------+                +-------------------+
          |                                    |
         :w------------> alt-tab ---------> invoke
```

This plugin lets you do this instead:

```
+-------------------+
| code code         |
| code              |-----\
|                   |     |
|-------------------| <Leader>r
| result result     |     |
| result            |<----/
|                   |
+-------------------+
```

Which saves tonnes of time.

It's useful for developing SQL queries, fast HTML previews, markdown-checking,
and anything that needs to pass through a shell command while you develop.

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

" Set the b:vimpipe_command variable for your buffer.
" The easiest way is to add an autocommand based on FileType.
autocmd FileType sql       :let b:vimpipe_command="psql mydatabase"
autocmd FileType markdown  :let b:vimpipe_command="multimarkdown"
```

Then, when you're editing the file, `<Leader>r` will send the buffer's content
to that command, and show the output in a new scratch buffer.

## Help

See :help vim-pipe for more.

## Credits

Thanks to Steve Losh for his excellent guide to Vimscript, [Learn Vimscript the Hard Way][learn_vimscript], and Meikel Brandmeye of [vimclojure][vimclojure] for the inspiration.


[learn_vimscript]: http://learnvimscriptthehardway.stevelosh.com/
[vimclojure]: https://github.com/kotarak/vimclojure
