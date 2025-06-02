(define-module (packages lua-language-server)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  ; #:use-module (guix build git)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages ninja)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages version-control)
  #:use-module (guix licenses))

(define-public lua-language-server
  (package
    (name "lua-language-server")
    (version "3.14.0") ; or a specific commit hash
    ; (version (git-version version "" commit))
    (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/LuaLS/lua-language-server.git")
                      (commit version)
                      (recursive? #t)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1cf8rq5hvzd83k8qax3av1201yzw9fcc0scj3598ldaw6054777s"))
                (modules '((guix build utils)))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'check)
         (replace 'build
           (lambda _
             (chdir "./3rd/luamake/")
             (system "sh ./compile/build.sh")
             (chdir "./../../")
             (system "./3rd/luamake/luamake rebuild")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (share-dir (string-append out "/share/lua-language-server")))
               ; (mkdir-p (string-append out "/bin"))
               (mkdir-p (string-append share-dir "/bin"))
               (copy-recursively "bin" (string-append share-dir "/bin"))
               (copy-file "main.lua" (string-append share-dir "/main.lua"))
               (copy-file "debugger.lua" (string-append share-dir "/debugger.lua"))
               (copy-file "changelog.md" (string-append share-dir "/changelog.md"))
               (copy-recursively "locale" (string-append share-dir "/locale"))
               (copy-recursively "meta" (string-append share-dir "/meta"))
               (copy-recursively "script" (string-append share-dir "/script")))))
         (add-after 'install 'make-wrapper
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (share-dir (string-append out "/share/lua-language-server"))
                    (luals-bin (string-append share-dir "/bin/lua-language-server"))
                    (bin-dir (string-append out "/bin"))
                    (cache-dir (string-append "${XDG_CACHE_HOME:-$HOME/.cache}")))
               (format #t "Output directory: ~a~%" out)
               (format #t "Binary path: ~a~%" bin-dir) 
               (if (file-exists? luals-bin)
                 (begin 
                   (mkdir-p bin-dir)
                   (with-output-to-file (string-append bin-dir "/lua-language-server")
                     (lambda ()
                       (display "#!/bin/sh\n")
                       (display (string-append "exec " luals-bin " -E " share-dir "/main.lua --logpath=" cache-dir "/lua-language-server/log --metapath=" cache-dir "/lua-language-server/meta \"$@\"\n"))))
                   (chmod (string-append bin-dir "/lua-language-server") #o755))
                 (error "Binary does not exists: ~a~%" luals-bin))
               )))
         )))
    (native-inputs
      (list ninja git))
    (inputs
      (list gcc))
    (outputs
     `("out"))
    (synopsis "Lua language server")
    (description "The Lua Language Server uses the Language Server Protocol to provide various features for Lua in your favourite code editors , making development easier, safer, and faster!")
    (home-page "https://github.com/LuaLS/lua-language-server")
    (license expat)))
