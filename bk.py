#!/usr/bin/env python
"""
bk: key-value pair interface
bk stores key-value pairs in a JSON file, and provides an interface to retrieve
values. The file can be specified with the environment variable $BK_FILE,
otherwise it is ~/.bk.json by default.
"""

import sys
import json
from os import path, getenv

BK_JSON = getenv("BK_FILE") or path.join(getenv("HOME"), ".bk.json")
sys.tracebacklimit = 0


def init_file():
    "Initialize bk store"
    with open(BK_JSON, "w") as bk_stream:
        print("{}", file=bk_stream)


def set_entry(key, value):
    "Set entry KEY in bk store to VALUE"
    if not path.isfile(BK_JSON):
        init_file()
    with open(BK_JSON, "r") as bk_stream:
        tmp = json.load(bk_stream)
    with open(BK_JSON, "w") as bk_stream:
        tmp[key] = value
        json.dump(tmp, bk_stream)


def retrieve(key):
    "Retrieve KEY from bk store"
    if not path.isfile(BK_JSON):
        init_file()
    with open(BK_JSON, "r") as bk_stream:
        dct = json.load(bk_stream)
        if key in dct:
            print(dct[key])
        else:
            print("")


def list_entries():
    "List keys in bk store"
    if not path.isfile(BK_JSON):
        init_file()
    with open(BK_JSON, "r") as bk_stream:
        print("\n".join(json.load(bk_stream).keys()).strip())


def delete_entry(key):
    "Delete entry KEY in bk store"
    with open(BK_JSON, "r") as bk_stream:
        tmp = json.load(bk_stream)
    with open(BK_JSON, "w") as bk_stream:
        del tmp[key]
        json.dump(tmp, bk_stream)


def show_help(exit_code=0):
    "Show the help message and exit with EXIT_CODE"
    print("""
bk: key-value pair interface
bk stores key-value pairs in a JSON file, and provides an interface to retrieve
values. The file can be specified with the environment variable $BK_FILE,
otherwise it is ~/.bk.json by default.

Usage:
  bk <options>
  bk <key>: retrieve value for <key>
  bk <key> <value>: set <key> to <value>

Options:
  --init
    initialize key-value store at $BK_FILE if set, or ~/.bk.json if not
  -l, --list
    list all keys
  -d <key>, --delete <key>
    delete <key> entry
  -h, --help
    show help (this message)""")
    sys.exit(exit_code)


if len(sys.argv) < 2:
    show_help(1)
elif sys.argv[1] in ["--init"]:
    init_file()
elif sys.argv[1] in ["--list", "-l"]:
    list_entries()
elif sys.argv[1] in ["--delete", "-d"]:
    delete_entry(sys.argv[2])
elif sys.argv[1] in ["--help", "-h"]:
    show_help(0)
elif len(sys.argv) == 2:
    retrieve(sys.argv[1])
else:
    set_entry(sys.argv[1], sys.argv[2])
