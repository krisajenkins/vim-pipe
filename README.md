# Vim Pipe - A Productivity-Boosting Plugin

## Do you do this?

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
* Clone this project into `~/.vim/bundle/vim-pipe`.
* Set a `b:vimpipe_command` variable for your buffer. The easiest way is to add
an autocommand based on FileType. For example, in your `.vimrc` file:

```vim
autocmd FileType sql      let b:vimpipe_command="psql mydatabase"
autocmd FileType markdown let b:vimpipe_command="multimarkdown"
```

See below for various examples.

## Usage & Tips

Once `b:vimpipe_command` is configured, type `<LocalLeader>r` to get the list
results.  There's no need to save the file first. It works on the current
buffer, not the contents on disk.

### PostgreSQL
```vim
autocmd FileType sql let b:vimpipe_command="psql mydatabase"
```

See also [vim-postgresql-syntax][vim-postgresql-syntax].

### Oracle

If you have an OPS$ login, it's as simple as:
```vim
autocmd FileType sql let b:vimpipe_command="sqlplus -s /"
```

### HTML

This is only text-based, obviously, but can still speed up initial development.

```vim
autocmd FileType html let b:vimpipe_command="lynx -dump -stdin"
```

### JavaScript

I usually run JavaScript in a browser, so I bind vim-pipe to JSLint, for
code-quality checking on-the-fly.

```vim
autocmd FileType javascript let b:vimpipe_command='jslint <(cat)'
```

Note: JSLint doesn't accept input on STDIN, so this configuration uses bash's
virtual file support. `<(cat)` takes the STDIN and re-presents it to look like a
regular file.

### JSON

I find attaching vim-pipe to a pretty-printer useful for development:

```vim
" Vim doesn't set a FileType for JSON, so we'll do it manually:
autocmd BufNewFile,BufReadPost *.json setlocal filetype=javascript.json

" Requires that you have Python v2.6+ installed. (Most *nix systems do.)
autocmd FileType json let b:vimpipe_command="python -m json.tool"
```

### Markdown

Fast-preview the HTML:

```vim
autocmd FileType mkd let b:vimpipe_command="multimarkdown"
autocmd FileType mkd let b:vimpipe_filetype="html"
```

Or combine wth the HTML tip to preview the rendered result:

```vim
autocmd FileType mkd let b:vimpipe_command="multimarkdown | lynx -dump -stdin"
```

### MongoDB

Is there an official FileType for MongoDB query files? Let's say it's `mongoql`, for all files `*.mql`:

```vim
autocmd BufNewFile,BufReadPost *.mql setlocal filetype=mongoql

autocmd FileType mongoql let b:vimpipe_command="mongo"
autocmd FileType mongoql let b:vimpipe_filetype="json"
```

Then try editing a file called `somequery.mql` with something like this in:

```
use books;
db.book.find( null, {author: 1, title: 1 });
db.runCommand( {dbStats: 1} );
```

## Help

See `:help vim-pipe` for more.

## Credits

Thanks to Steve Losh for his excellent guide to Vimscript, [Learn Vimscript the Hard Way][learnvim], and Meikel Brandmeye of [vimclojure][vimclojure] for the inspiration.

[pathogen]: https://github.com/tpope/vim-pathogen/
[learnvim]: http://learnvimscriptthehardway.stevelosh.com/
[vimclojure]: https://github.com/kotarak/vimclojure
[vim-postgresql-syntax]: https://github.com/krisajenkins/vim-postgresql-syntax
