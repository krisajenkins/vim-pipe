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
         :w -----------> alt-tab ---------> invoke
```

This plugin lets you do this instead:

```
+-------------------+
| code code         |
| code              |---------\
|                   |         |
|-------------------|   <LocalLeader>r
| result result     |         |
| result            |<--------/
|                   |
+-------------------+
```

Which saves tonnes of time. It's even faster than using screen or tmux.

It's useful for developing SQL queries, fast HTML previews, markdown-checking,
and anything that needs to pass through a shell command while you develop.

## Detail

You associate a shell command with your file, something that will take your
buffer on STDIN and show the result on STDOUT. For example, if you're editing an
SQL query, that command might be `psql mydatabase`.

Having done that, `<LocalLeader>r` will run the current buffer against that
command and show you the results. You no longer need to
save-switch-execute-switch, which makes life faster and easier.

## Installation

* Install [Pathogen][pathogen]. (You're already using Pathogen, right?)
* Clone this project into `~/.vim/bundle/`.
* Set a `b:vimpipe_command` variable for your buffer. The easiest way is to add
an autocommand based on FileType. For example, in your `.vimrc` file:

```vim
autocmd FileType sql       :let b:vimpipe_command="psql mydatabase"
autocmd FileType markdown  :let b:vimpipe_command="multimarkdown"
```

Then, when you're editing the file, `<LocalLeader>r` will send the buffer's
content to that command, and show the output in a new scratch buffer.

## Help

See `:help vim-pipe` for more.

## Tips

### Oracle

If you have an OPS$ login, it's as simple as:
```vim
autocmd FileType sql :let b:vimpipe_command="sqlplus /"
```

### HTML

This is only text-based, obviously, but can still speed up initial development.
```vim
autocmd FileType html :let b:vimpipe_command="lynx -dump -stdin"
```

### Markdown

Fast-preview the HTML:

```vim
autocmd FileType mkd :let b:vimpipe_command="multimarkdown"
```

Or combine wth the HTML tip to preview the rendered result:

```vim
autocmd FileType mkd :let b:vimpipe_command="multimarkdown | lynx -dump -stdin"
```

## Credits

Thanks to Steve Losh for his excellent guide to Vimscript, [Learn Vimscript the Hard Way][learnvim], and Meikel Brandmeye of [vimclojure][vimclojure] for the inspiration.


[pathogen]: https://github.com/tpope/vim-pathogen/
[learnvim]: http://learnvimscriptthehardway.stevelosh.com/
[vimclojure]: https://github.com/kotarak/vimclojure
