complete -c bk -d "Key-value store for command line bookmarks"
complete -c bk -xa "(bk --list)"
complete -c bk -s l -l list -d "List entries"
complete -c bk -s h -l help -d "Show help"
complete -c bk -l init -d "Initialize bk store"
complete -c bk -s d -l delete -d "Delete entry" -xa "(bk --list)"
