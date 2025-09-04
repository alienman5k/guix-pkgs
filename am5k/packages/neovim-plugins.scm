(define-module (am5k packages neovim-plugins)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system)
  #:use-module (guix build-system vim)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system copy)
  #:use-module (guix build utils)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages rust)
  #:use-module (guix gexp))

; (define-public blink-cmp-fuzzy
;   (package
;     (name "blink-cmp-fuzzy")
;     (version "1.6.0")
;     (source
;      (origin
;        (method git-fetch)
;        (uri (git-reference
;              (url "https://github.com/Saghen/blink.cmp")
;              (commit (string-append "v" version))))
;        (file-name (git-file-name name version))
;        (sha256
;         (base32 "0af09kssb9n2dxmf2i79kgdnln6f42nba5gg391y4gqqly05hx10"))))
;     (build-system cargo-build-system)
;     (arguments
;      (list
; 			 #:install-source? #f
; 			))
; 		(inputs `(("bincode" ,rust-bincode-1.3.3)
; 							("blake3" ,rust-blake3-1.8.2)
; 							("regex" ,rust-regex-1.11.1)))
;     (home-page "https://github.com/Saghen/blink.cmp")
;     (synopsis
;      "Completion plugin with support for LSPs, cmdline, signature help and snippets")
;     (description
;      "blink.cmp is a completion plugin with support for LSPs, cmdline, signature help and snippets. It uses an optional custom fuzzy matcher for typo resistance. It provides extensibility via pluggable sources (LSP, buffer, snippets, etc), component based rendering and scripting for the configuration.")
;     (license license:expat)))
;
; (define* (call-with-downloaded-file url proc #:optional (error-thunk #f))
;   "Fetch URL, store the content in a temporary file and call PROC with that
; file.  Returns the value returned by PROC.  On error call ERROR-THUNK and
; return its value or leave if it's false."
;   (catch #t
;     (lambda ()
;       (proc (http-fetch/cached (string->uri url))))
;     (lambda (key . args)
;       (if error-thunk
;           (error-thunk)
;           (leave (G_ "~A: download failed~%") url)))))
;

(define-public blink-cmp-fuzzy-bin
	(package
		(name "blink-cmp-fuzzy-bin")
		(version "1.6.0")
		(source
			(origin
				(method url-fetch)
				;;https://github.com/Saghen/blink.cmp/releases/download/v1.6.0/x86_64-unknown-linux-gnu.so
				; (uri (string-append "https://github.com/Saghen/blink.cmp/releases/download/v" version "/" (getenv "HOSTTYPE") "-unknown-linux-gnu.so"))
				(uri (string-append "https://github.com/Saghen/blink.cmp/releases/download/v" version "/" "x86_64-unknown-linux-gnu.so"))
				(sha256
				 (base32 "00c24kai48ycciis5snmz41jx8zkvhxsz8hlj26zsagdzr9asnii"))))
		(build-system copy-build-system)
    (home-page "https://github.com/Saghen/blink.cmp")
    (synopsis "Completion plugin with support for LSPs, cmdline, signature help and snippets")
    (description "blink.cmp is a completion plugin with support for LSPs, cmdline, signature help and snippets. It uses an optional custom fuzzy matcher for typo resistance. It provides extensibility via pluggable sources (LSP, buffer, snippets, etc), component based rendering and scripting for the configuration.")
    (license license:expat)))

;;TODO: This won't work properly unless we can also build blink-cmp-fuzzy dependency, 
;;      unless fuzzy implementation is set to Lua, see https://cmp.saghen.dev/configuration/fuzzy.html
(define-public blink-cmp
  (package
    (name "neovim-blink.cmp")
    (version "1.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Saghen/blink.cmp")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0af09kssb9n2dxmf2i79kgdnln6f42nba5gg391y4gqqly05hx10"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "blink.cmp"
		  #:phases
			#~(modify-phases %standard-phases
				 (add-after 'install 'copy-fuzzy
				  (lambda* (#:key inputs outputs #:allow-other-keys)
									 (let ((out (assoc-ref outputs "out"))
										     (fuzzy (assoc-ref inputs "blink-cmp-fuzzy-bin")))
									   (format #t "~a~%" fuzzy)
									   (format #t "~a~%" out)
										 (invoke "ls" "-l" fuzzy)
										 (mkdir-p (string-append out "/share/nvim/site/pack/guix/start/blink.cmp/target/release"))
										 (copy-file (string-append fuzzy "/x86_64-unknown-linux-gnu.so") (string-append out "/share/nvim/site/pack/guix/start/blink.cmp/target/release/libblink_cmp_fuzzy.so"))
										 )))
				 )
		 )
		)
		(native-inputs
			(list blink-cmp-fuzzy-bin))
    (home-page "https://github.com/Saghen/blink.cmp")
    (synopsis
     "Completion plugin with support for LSPs, cmdline, signature help and snippets")
    (description
     "blink.cmp is a completion plugin with support for LSPs, cmdline, signature help and snippets. It uses an optional custom fuzzy matcher for typo resistance. It provides extensibility via pluggable sources (LSP, buffer, snippets, etc), component based rendering and scripting for the configuration.")
    (license license:expat)))

; (define-public mini
;   (package
;     (name "neovim-mini")
;     (version "0.16.0")
;     (source
;      (origin
;        (method git-fetch)
;        (uri (git-reference
;              (url "https://github.com/nvim-mini/mini.diff")
;              (commit (string-append "v" version))))
;        (file-name (git-file-name name version))
;        (sha256
;         (base32 "1gb5l58vmyiknk7nhyn2r3d02yd4jsd5kpv3q59ja7pzdi0dyng4"))))
;     (build-system vim-build-system)
;     (arguments
;      (list
;       #:plugin-name "mini")
; 		  #:mode "opt")
;     (home-page "https://github.com/nvim-mini/mini.diff")
;     (synopsis "Work with diff hunks")
;     (description "Neovim pluing to help working with diff and hunks.")
;     (license license:expat)))

(define-public mini-diff
  (package
    (name "neovim-mini.diff")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.diff")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1gb5l58vmyiknk7nhyn2r3d02yd4jsd5kpv3q59ja7pzdi0dyng4"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.diff"
			#:mode "opt"))
    (home-page "https://github.com/nvim-mini/mini.diff")
    (synopsis "Work with diff hunks")
    (description "Neovim pluing to help working with diff and hunks.")
    (license license:expat)))

(define-public mini-files
  (package
    (name "neovim-mini.files")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.files")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "12027xb9907zk145hsx6qniq1cjm8bm5405njq4cs9vx992pafsh"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.files"
			#:mode "opt"))
    (home-page "https://github.com/nvim-mini/mini.files")
    (synopsis "Navigate and manipulate file system")
    (description
     "Neovim pluing that allows Navigation and manipulation of the file system.")
    (license license:expat)))

(define-public mini-git
  (package
    (name "neovim-mini.git")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini-git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vf0ys710yf1apalglxj7kcdyrnrd7jkz1ksi9v1vj3h60pvany2"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.git"
			#:mode "opt"))
    (home-page "https://github.com/nvim-mini/mini-git")
    (synopsis "Navigate and manipulate file system")
    (description
     "Neovim pluing that allows Navigation and manipulation of the file system.")
    (license license:expat)))

(define-public mini-icons
  (package
    (name "neovim-mini.icons")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.icons")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "110bglbbyafjym4md2slgccyjhf90bgg8h9h2ipya6cfqfs4pizy"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.icons"))
    (home-page "https://github.com/nvim-mini/mini.icons")
    (synopsis "Icon provider.")
    (description "Icon provider.")
    (license license:expat)))

(define-public mini-indentscope
  (package
    (name "neovim-mini.indentscope")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.indentscope")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1xk31bl9gchc8r1pv6f2z7nfkr6q7f1i4qrrj3h4crxb6nhpxmry"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.indentscope"))
    (home-page "https://github.com/nvim-mini/mini.indentscope")
    (synopsis "Visualize and work with indent scope")
    (description "Visualize and work with indent scope")
    (license license:expat)))

(define-public mini-pick
  (package
    (name "neovim-mini.pick")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.pick")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wqb0fisg5yd2g4b6zd8668axf8zwqd7a6vyxzzq2rd0qh9jkpa8"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.pick"))
    (home-page "https://github.com/nvim-mini/mini.pick")
    (synopsis "Navigate and manipulate file system")
    (description
     "Neovim pluing that allows Navigation and manipulation of the file system.")
    (license license:expat)))

(define-public mini-pick-latest
  (package
    (inherit mini-pick)
    (name "neovim-mini.pick")
    (version "latest")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.pick")
             (commit "be6490ae9d7038b9f5185d95a8060054f9b23666")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yhwb8c44n7bzcqa7vwrh5fqxc6qgx1bxqph43f2sajsgnfd1vhp"))))))

(define-public mini-statusline
  (package
    (name "neovim-mini.statusline")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.statusline")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1hhd4fln3m04d9v5pwa3mb1n4nifsilrxp8hs14njcgk2rxv6qar"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.statusline"))
    (home-page "https://github.com/nvim-mini/mini.statusline")
    (synopsis
     "Minimal and fast statusline module with opinionated default look.")
    (description
     "Minimal and fast statusline module with opinionated default look.")
    (license license:expat)))

(define-public solarized
  (package
    (name "neovim-solarized")
    (version "3.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/maxmx03/solarized.nvim")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1fz1wc569w26aanmj3hhsc17xrx29g6bfsjsbgssa7jq76aavp3w"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "solarized"))
    (home-page "https://github.com/maxmx03/solarized.nvim")
    (synopsis "Solarized ColorScheme for Neovim")
    (description
     "Solarized is a sixteen color palette (eight monotones, eight accent colors) designed for use with terminal and gui applications.")
    (license license:expat)))

(define-public catppuccin
  (package
    (name "neovim-catppuccin")
    (version "1.11.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/catppuccin/nvim")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1p5j53vzi14vm39qyb9c8wpbzd2ywy1z9cqw782vz3gccis1zngs"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "catppuccin"))
    (home-page "https://github.com/catppuccin/nvim")
    (synopsis "Catppuccin for (Neo)vim.")
    (description
     "This port of Catppuccin is special because it was the first one and the one that originated the project itself. Given this, it's important to acknowledge that it all didn't come to be what it is now out of nowhere.")
    (license license:expat)))

(define-public nvim-treesitter
  (package
    (name "neovim-nvim-treesitter")
    (version "0.10.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-treesitter/nvim-treesitter")
             (commit "42fc28ba918343ebfd5565147a42a26580579482")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ck1qslxwi18qxrga68blvk1dg9j4jn65xiw8snq5pk06waksnq9"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "nvim-treesitter"))
    (home-page "https://github.com/nvim-treesitter/nvim-treesitter")
    (synopsis "Treesitter configurations and abstraction layer for Neovim.")
    (description
     "The goal of nvim-treesitter is both to provide a simple and easy way to use the interface for tree-sitter in Neovim and to provide some basic functionality such as highlighting based on it.")
    (license license:expat)))

(define-public nvim-jdtls
  (package
    (name "neovim-nvim-jdtls")
    (version "latest")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mfussenegger/nvim-jdtls")
             (commit "8eee2302598bad61c5674dc04d7e93cfd85f46f6")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02hbiml5i6fw7cb3v7434jppvygl4rjngrf29ls2ridd1wqy6hlr"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "nvim-jdtls"))
    (home-page "https://github.com/mfussenegger/nvim-jdtls")
    (synopsis "Extensions for the built-in Language Server Protocol support in Neovim (>= 0.6.0) for eclipse.jdt.ls.")
    (description
     "Extensions for the built-in Language Server Protocol support in Neovim (>= 0.6.0) for eclipse.jdt.ls.")
    (license license:expat)))
