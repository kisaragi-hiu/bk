# bk: command-line key-value storage

`bk` stores key-value pairs in a JSON file, and provides an interface to retrieve values. It is intended for command line bookmarks.

## Why

I wrote this mainly for command line bookmarks, so I can do `cd (bk projects)` to quickly get to my projects folder, for example.

I don't want to use shell variables because it can potentially intefere with some scripts, and because they have character restrictions quite a lot stricter than JSON strings, the way I'm storing it here.

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
- `-d <key>`, `--delete <key>`  
    Delete `key`.
- `--init [--force]`  
    Initialize key-value store.
    --force overwrites the current file if it exists.
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
$ bk --delete conf-kitty
$ bk --list

$ cat ~/.bk.json
{}
```
