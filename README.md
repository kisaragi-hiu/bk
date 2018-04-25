# bk: command-line persistant key-value storage

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
