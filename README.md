# bk: command-line key-value storage

`bk` stores key-value pairs in a JSON file, and provides an interface to retrieve values. It is intended for command line bookmarks.

## Usage

- `bk <key>`
    Retrieve value for `key`.
- `bk <key> <value>`
    Set `key` to `value`.
- `bk <options>`
    See below.

## Options

- `-l`, `--list`
    List all keys.
- `-a`, `--list-all`
    List all keys and values.
- `-d <key>`, `--delete <key>`
    Delete `key`.
- `-h`, `--help`
    Show help.

## Examples
```sh
$ cat ~/.bk.json
{}
$ bk conf-kitty $HOME/.config/kitty/kitty.conf
$ bk conf-kitty
/home/flyin1501/.config/kitty/kitty.conf
$ cat ~/.bk.json
{"conf-kitty":"/home/flyin1501/.config/kitty/kitty.conf"}
$ bk --list
conf-kitty
$ bk --list-all
conf-kitty: /home/flyin1501/.config/kitty/kitty.conf
$ bk --delete conf-kitty
$ bk --list

$ cat ~/.bk.json
{}
```

## TODO

- Rewrite in a language with faster startup time.
- Initialize a new file if none exists.
- Shell completion. This is quite important for this to actually be convenient.
