#!/usr/bin/env racket
#lang racket
(require lens
         threading
         json)

(define (help [error-code 0])
  (displayln "
bk: key-value pair interface
bk stores key-value pairs in a JSON file, and provides an interface to retrieve values. The file can be specified with the environment variable $BK_FILE, otherwise it is ~/.bk.json by default.

Usage:
  bk <options>
  bk <key>: retrieve value for <key>
  bk <key> <value>: set <key> to <value>

Options:
  --init
    initialize key-value store at $BK_FILE if set, or ~/.bk.json if not
  --init --force
    initialize key-value store, overwriting the existing file
  -l, --list
    list all keys
  -d <key>, --delete <key>
    delete <key> entry
  -h, --help
    show help (this message)")
  (exit error-code))

(define (list-entries)
  "List entries in bk-json"
  (unless (file-exists? bk-json)
    (init-file))
  (define f bk-json)
  (displayln
    (~> (string->jsexpr (file->string f))
        hash-keys
        (map symbol->string _)
        (string-join _ "\n"))))

(define (delete-entry! args)
  "Delete an entry in bk-json"
  (unless (file-exists? bk-json)
    (init-file))
  ;; handle argument checks in here
  (unless (> (vector-length args) 1)
    (error 'delete-entry "further argument needed for --delete"))
  ;; save the file contents first
  (define s (file->string bk-json))
  (call-with-output-file
    bk-json
    #:exists 'truncate
    (λ (f)
       (displayln
         (~> (string->jsexpr s)
             (hash-remove _ (string->symbol (vector-ref args 1)))
             jsexpr->string)
         f))))

(define (retrieve-or-set args)
  "Retrive an entry from bk-json, or set the value for an entry if given"
  (cond
    [(= (vector-length args) 1) (retrieve (vector-ref args 0))]
    [else (bk-set (vector-ref args 0) (vector-ref args 1))]))

(define (retrieve key)
  (unless (file-exists? bk-json)
    (init-file))
  (displayln (hash-ref (string->jsexpr (file->string bk-json))
                       (string->symbol key)
                       ;; Non-existent key represents empty string
                       "")))

(define (bk-set key value)
  (unless (file-exists? bk-json)
    (init-file))
  (define s (file->string bk-json))
  (call-with-output-file
    bk-json
    #:exists 'truncate
    (λ (f)
       (displayln
         (~> (string->jsexpr s)
             (hash-set _ (string->symbol key) value)
             jsexpr->string)
         f))))

(define (init-file [overwrite? #f])
  ;; call-with-output-file #:exists 'update seems to keep some old file content
  ;; just delete the old one if it exists and we've been instructed to
  (when (and overwrite? (file-exists? bk-json))
    (delete-file bk-json))
  (call-with-output-file bk-json (λ (f) (displayln "{}" f))))

(define args (current-command-line-arguments))
(define bk-json
  (or (getenv "BK_FILE")
      (build-path (getenv "HOME") ".bk.json")))

(unless (> (vector-length args) 0)
  (help 1))

(case (vector-ref args 0)
  [("--list" "-l") (list-entries)]
  [("--delete" "-d") (delete-entry! args)]
  [("--help" "-h" "-?") (help)]
  [("--init") (init-file (and (> (vector-length args) 1)
                              (equal? (vector-ref args 1) "--force")))]
  [else (retrieve-or-set args)])

;; vim: filetype=racket
;; Local Variables:
;; mode: racket
;; End: