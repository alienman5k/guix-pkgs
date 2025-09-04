(define-module (am5k packages neovim)
  #:use-module (am5k packages tree-sitter)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages tree-sitter)
  #:use-module (gnu packages serialization)
  #:use-module (guix gexp))

(define-public nvim
  (package
    (inherit neovim)
    (name "neovim")
    (version "0.11.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neovim/neovim")
                    (commit "b2684d9f6658544d75e2431a06bcf21fe80673f8")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "07kg1wkv0dhxj8a1xfzj2dnwsp232vd16n1j6jyxs0vvcqqbg5jj"))))
    (arguments
     (list #:tests? #f
           #:modules
           '((srfi srfi-26) (guix build cmake-build-system)
             (guix build utils))
           #:build-type "Release"
           #:configure-flags
           #~(list #$@(if (member (if (%current-target-system)
                                      (gnu-triplet->nix-system (%current-target-system))
                                      (%current-system))
                                  (package-supported-systems luajit))
                          '()
                          '("-DPREFER_LUA:BOOL=YES")))
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'unpack 'set-lua-paths
                 (lambda* _
                   (let* ((lua-version "5.1")
                          (lua-cpath-spec (lambda (prefix)
                                            (let ((path (string-append
                                                         prefix
                                                         "/lib/lua/"
                                                         lua-version)))
                                              (string-append
                                               path
                                               "/?.so;"
                                               path
                                               "/?/?.so"))))
                          (lua-path-spec (lambda (prefix)
                                           (let ((path (string-append prefix
                                                        "/share/lua/"
                                                        lua-version)))
                                             (string-append path "/?.lua;"
                                                            path "/?/?.lua"))))
                          (lua-inputs (list (or #$(this-package-input "lua")
                                                #$(this-package-input "luajit"))
                                            #$lua5.1-luv
                                            #$lua5.1-lpeg
                                            #$lua5.1-bitop
                                            #$lua5.1-libmpack)))
                     (setenv "LUA_PATH"
                             (string-join (map lua-path-spec lua-inputs) ";"))
                     (setenv "LUA_CPATH"
                             (string-join (map lua-cpath-spec lua-inputs) ";"))
                     #t)))
               (add-after 'unpack 'prevent-embedding-gcc-store-path
                 (lambda _
                   ;; nvim remembers its build options, including the compiler with
                   ;; its complete path.  This adds gcc to the closure of nvim, which
                   ;; doubles its size.  We remove the reference here.
                   (substitute* "cmake.config/versiondef.h.in"
                     (("\\$\\{CMAKE_C_COMPILER\\}") "/gnu/store/.../bin/gcc"))
                   #t))
                (add-after 'install 'copy-treesitter-parsers
                           (lambda* (#:key inputs outputs #:allow-other-keys)
                                   (let* ((out (assoc-ref outputs "out"))
                                         (ts-c (assoc-ref inputs "tree-sitter-c"))
                                         (ts-lua (assoc-ref inputs "tree-sitter-lua"))
                                         (ts-md (assoc-ref inputs "tree-sitter-markdown"))
                                         (ts-query (assoc-ref inputs "tree-sitter-query"))
                                         (ts-vim (assoc-ref inputs "tree-sitter-vim"))
                                         (ts-vimdoc (assoc-ref inputs "tree-sitter-vimdoc"))
                                         (parser-dir (string-append out "/lib/nvim/parser" )))
                                     ; (display (string-append "Copying parser dir to: " out "\n"))
                                     ; (format #t "Current directory: ~a~%" (getenv "PWD"))
                                     ; (format #t "Parser directory: ~a~%" parser-dir)
                                     ; (format #t "Tree-Sitter LUA directory: ~a~%" ts-lua)
                                     ; (format #t "Tree-Sitter MD directory: ~a~%" ts-md)
                                     (format #t "Tree-Sitter VIM directory: ~a~%" ts-vim)
                                     (format #t "Tree-Sitter VIMDOC directory: ~a~%" ts-vimdoc)
                                     ; (invoke "ls" "lib/")
                                     ; (invoke "ls" (string-append ts-lua "/lib/tree-sitter/libtree-sitter-lua.so"))
                                     (mkdir-p parser-dir)
                                     ; (invoke "ls" parser-dir)
                                     (copy-file (string-append ts-c "/lib/tree-sitter/libtree-sitter-c.so") (string-append parser-dir "/c.so"))
                                     (copy-file (string-append ts-lua "/lib/tree-sitter/libtree-sitter-lua.so") (string-append parser-dir "/lua.so"))
                                     (copy-file (string-append ts-md "/lib/tree-sitter/libtree-sitter-markdown.so") (string-append parser-dir "/markdown.so"))
                                     (copy-file (string-append ts-md "/lib/tree-sitter/libtree-sitter-markdown_inline.so") (string-append parser-dir "/markdown_inline.so"))
                                     (copy-file (string-append ts-vim "/lib/tree-sitter/libtree-sitter-vim.so") (string-append parser-dir "/vim.so"))
                                     (copy-file (string-append ts-vimdoc "/lib/tree-sitter/libtree-sitter-vimdoc.so") (string-append parser-dir "/vimdoc.so")))
                            )))))
    (native-inputs
      (list tree-sitter-c
            tree-sitter-lua
            tree-sitter-markdown 
            tree-sitter-query
            tree-sitter-vim
            tree-sitter-vimdoc))))


(define-public nvim-0.11.4
  (package
    (inherit nvim)
    (name "neovim")
    (version "0.11.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neovim/neovim")
                    (commit "cec0ecabd8f47ff81dcb52e8fc9003e365563a84")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1c1zah52p93vqrw18fh5xppnrqrqb6xh8n4nzwi8nksrscgq8hqp"))))))

(define-public nvim-dev
  (package
    (inherit nvim)
    (name "neovim")
    (version "0.12.0-dev")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neovim/neovim")
                    (commit "f9ce939bf53b84f7e6e4ecca3875dd0c378991db")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1c1zah52p93vqrw18fh5xppnrqrqb6xh8n4nzwi8nksrscgq8hqp"))))))


; (define-public nvim-latest
;   (package
;     (inherit neovim)
;     (name "neovim")
;     (version "latest")
;     (source (origin
;               (method git-fetch)
;               (uri (git-reference
;                     (url "https://github.com/neovim/neovim")
;                     (commit "f9ce939bf53b84f7e6e4ecca3875dd0c378991db")))
;               (file-name (git-file-name name version))
;               (sha256
;                (base32
;                 "07kg1wkv0dhxj8a1xfzj2dnwsp232vd16n1j6jyxs0vvcqqbg5jj"))))
;     (arguments
;      (list #:tests? #f
;            #:modules
;            '((srfi srfi-26) (guix build cmake-build-system)
;              (guix build utils))
;            #:build-type "Release"
;            #:configure-flags
;            #~(list #$@(if (member (if (%current-target-system)
;                                       (gnu-triplet->nix-system (%current-target-system))
;                                       (%current-system))
;                                   (package-supported-systems luajit))
;                           '()
;                           '("-DPREFER_LUA:BOOL=YES")))
;            #:phases
;            #~(modify-phases %standard-phases
;                (add-after 'unpack 'set-lua-paths
;                  (lambda* _
;                    (let* ((lua-version "5.1")
;                           (lua-cpath-spec (lambda (prefix)
;                                             (let ((path (string-append
;                                                          prefix
;                                                          "/lib/lua/"
;                                                          lua-version)))
;                                               (string-append
;                                                path
;                                                "/?.so;"
;                                                path
;                                                "/?/?.so"))))
;                           (lua-path-spec (lambda (prefix)
;                                            (let ((path (string-append prefix
;                                                         "/share/lua/"
;                                                         lua-version)))
;                                              (string-append path "/?.lua;"
;                                                             path "/?/?.lua"))))
;                           (lua-inputs (list (or #$(this-package-input "lua")
;                                                 #$(this-package-input "luajit"))
;                                             #$lua5.1-luv
;                                             #$lua5.1-lpeg
;                                             #$lua5.1-bitop
;                                             #$lua5.1-libmpack)))
;                      (setenv "LUA_PATH"
;                              (string-join (map lua-path-spec lua-inputs) ";"))
;                      (setenv "LUA_CPATH"
;                              (string-join (map lua-cpath-spec lua-inputs) ";"))
;                      #t)))
;                (add-after 'unpack 'prevent-embedding-gcc-store-path
;                  (lambda _
;                    ;; nvim remembers its build options, including the compiler with
;                    ;; its complete path.  This adds gcc to the closure of nvim, which
;                    ;; doubles its size.  We remove the reference here.
;                    (substitute* "cmake.config/versiondef.h.in"
;                      (("\\$\\{CMAKE_C_COMPILER\\}") "/gnu/store/.../bin/gcc"))
;                    #t))
;                 (add-after 'install 'copy-treesitter-parsers
;                            (lambda* (#:key inputs outputs #:allow-other-keys)
;                                    (let* ((out (assoc-ref outputs "out"))
;                                          (ts-c (assoc-ref inputs "tree-sitter-c"))
;                                          (ts-lua (assoc-ref inputs "tree-sitter-lua"))
;                                          (ts-md (assoc-ref inputs "tree-sitter-markdown"))
;                                          (ts-query (assoc-ref inputs "tree-sitter-query"))
;                                          (ts-vim (assoc-ref inputs "tree-sitter-vim"))
;                                          (ts-vimdoc (assoc-ref inputs "tree-sitter-vimdoc"))
;                                          (parser-dir (string-append out "/lib/nvim/parser" )))
;                                      ; (display (string-append "Copying parser dir to: " out "\n"))
;                                      ; (format #t "Current directory: ~a~%" (getenv "PWD"))
;                                      ; (format #t "Parser directory: ~a~%" parser-dir)
;                                      ; (format #t "Tree-Sitter LUA directory: ~a~%" ts-lua)
;                                      ; (format #t "Tree-Sitter MD directory: ~a~%" ts-md)
;                                      (format #t "Tree-Sitter VIM directory: ~a~%" ts-vim)
;                                      (format #t "Tree-Sitter VIMDOC directory: ~a~%" ts-vimdoc)
;                                      ; (invoke "ls" "lib/")
;                                      ; (invoke "ls" (string-append ts-lua "/lib/tree-sitter/libtree-sitter-lua.so"))
;                                      (mkdir-p parser-dir)
;                                      ; (invoke "ls" parser-dir)
;                                      (copy-file (string-append ts-c "/lib/tree-sitter/libtree-sitter-c.so") (string-append parser-dir "/c.so"))
;                                      (copy-file (string-append ts-lua "/lib/tree-sitter/libtree-sitter-lua.so") (string-append parser-dir "/lua.so"))
;                                      (copy-file (string-append ts-md "/lib/tree-sitter/libtree-sitter-markdown.so") (string-append parser-dir "/markdown.so"))
;                                      (copy-file (string-append ts-md "/lib/tree-sitter/libtree-sitter-markdown_inline.so") (string-append parser-dir "/markdown_inline.so"))
;                                      (copy-file (string-append ts-vim "/lib/tree-sitter/libtree-sitter-vim.so") (string-append parser-dir "/vim.so"))
;                                      (copy-file (string-append ts-vimdoc "/lib/tree-sitter/libtree-sitter-vimdoc.so") (string-append parser-dir "/vimdoc.so")))
;                             )))))
;     (native-inputs
;       (list tree-sitter-c
;             tree-sitter-lua
;             tree-sitter-markdown 
;             tree-sitter-query
;             tree-sitter-vim
;             tree-sitter-vimdoc))))
