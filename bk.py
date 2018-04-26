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

bk_json = path.join(getenv("HOME"), ".bk.json")


def set_entry(key, value):
    with open(bk_json, "r") as f:
        tmp = json.load(f)
    with open(bk_json, "w") as f:
    "Set entry KEY in bk store to VALUE"
        tmp[key] = value
        json.dump(tmp, f)


def retrieve(key):
    with open(bk_json, "r") as f:
        print(json.load(f)[key])
    "Retrieve KEY from bk store"


def list_entries():
    S = ""
    with open(bk_json, "r") as f:
        for i in json.load(f).keys():
            S += i + "\n"
    print(S.strip())
    "List keys in bk store"


def delete_entry(key):
    with open(bk_json, "r") as f:
        tmp = json.load(f)
    with open(bk_json, "w") as f:
    "Delete entry KEY in bk store"
        del tmp[key]
        json.dump(tmp, f)


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
  -l, --list
    list all keys
  -a, --list-all
    list all keys with their values
  -d <key>, --delete <key>
    delete <key> entry
  -h, --help
    show help (this message)""")
    sys.exit(exit_code)


if len(sys.argv) < 2:
    show_help(1)
elif sys.argv[1] in ["--list", "-l"]:
    list_entries()
elif sys.argv[1] in ["--delete", "-d"]:
    delete_entry(sys.argv[2])
elif sys.argv[1] in ["--help", "-h"]:
    show_help(0)
elif len(sys.argv) == 2:
    retrieve(sys.argv[2])
else:
    set_entry(sys.argv[2], sys.argv[3])
