(define-module (am5k packages neovim-plugins)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system)
  #:use-module (guix build-system vim)
  ; #:use-module (guix build-system cargo)
  #:use-module (guix build-system copy)
  #:use-module (guix build utils)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages curl)
  ; #:use-module (gnu packages rust)
  #:use-module (guix gexp))

(define-public blink-cmp-fuzzy-bin
  (package
    (name "blink-cmp-fuzzy-bin")
    (version "1.6.0")
    (source
     (origin
       (method url-fetch)
       ;; https://github.com/Saghen/blink.cmp/releases/download/v1.6.0/x86_64-unknown-linux-gnu.so
       ;; (uri (string-append "https://github.com/Saghen/blink.cmp/releases/download/v" version "/" (getenv "HOSTTYPE") "-unknown-linux-gnu.so"))
       (uri (string-append
             "https://github.com/Saghen/blink.cmp/releases/download/v" version
             "/" "x86_64-unknown-linux-gnu.so"))
       (sha256
        (base32 "00c24kai48ycciis5snmz41jx8zkvhxsz8hlj26zsagdzr9asnii"))))
    (build-system copy-build-system)
    (home-page "https://github.com/Saghen/blink.cmp")
    (synopsis
     "Completion plugin with support for LSPs, cmdline, signature help and snippets")
    (description
     "blink.cmp is a completion plugin with support for LSPs, cmdline, signature help and snippets. It uses an optional custom fuzzy matcher for typo resistance. It provides extensibility via pluggable sources (LSP, buffer, snippets, etc), component based rendering and scripting for the configuration.")
    (license license:expat)))

;;TODO: This won't work properly unless we can also build blink-cmp-fuzzy dependency, 
;;      unless fuzzy implementation is set to Lua, see https://cmp.saghen.dev/configuration/fuzzy.html
(define-public blink-cmp
  (package
    (name "neovim-blink.cmp")
    (version "1.8.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Saghen/blink.cmp")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0nh0ajmxam9anbk62r71aar48cgakf5n1h90snprzx7g7qz5qf96"))))
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
                (mkdir-p (string-append out
                          "/share/nvim/site/pack/guix/start/blink.cmp/target/release"))
                (copy-file (string-append fuzzy "/x86_64-unknown-linux-gnu.so")
                           (string-append out
                            "/share/nvim/site/pack/guix/start/blink.cmp/target/release/libblink_cmp_fuzzy.so"))))))))
    (native-inputs (list blink-cmp-fuzzy-bin))
    (home-page "https://github.com/Saghen/blink.cmp")
    (synopsis
     "Completion plugin with support for LSPs, cmdline, signature help and snippets")
    (description
     "blink.cmp is a completion plugin with support for LSPs, cmdline, signature help and snippets. It uses an optional custom fuzzy matcher for typo resistance. It provides extensibility via pluggable sources (LSP, buffer, snippets, etc), component based rendering and scripting for the configuration.")
    (license license:expat)))

(define-public codecompanion
  (package
    (name "neovim-codecompanion")
    (version "19.11.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/olimorris/codecompanion.nvim")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0w414bipcx444lll66axn6p1aa5wvikzh6am7awil25r18ddrk6g"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "codecompanion"))
    (home-page "https://github.com/olimorris/codecompanion.nvim")
    (synopsis "Pluging to code with LLMs from inside Neovim.")
    (description
     "Code with LLMs and Agents via the in-built adapters, the community adapters or by building your own.")
    (license license:expat)))

; (define-public mini
;   (package
;     (name "neovim-mini")
;     (version "0.17.0")
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
;       #:plugin-name "mini"))
;     (home-page "https://github.com/nvim-mini/mini.diff")
;     (synopsis "Work with diff hunks")
;     (description "Neovim pluing to help working with diff and hunks.")
;     (license license:expat)))

(define-public mini-clue
  (package
    (name "neovim-mini.clue")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.clue")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1w5hv0jgvzzivmkp7jzgi5nzh11bj5m94c6m2ad8dvcn5hffpw4a"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.clue"))
    (home-page "https://github.com/nvim-mini/mini.clue")
    (synopsis "Show next key clues")
    (description "Show next key clues.")
    (license license:expat)))

(define-public mini-completion
  (package
    (name "neovim-mini.completion")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.completion")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "025462vqfyp07gcslz71dd57pypi9d7awgm3vsjb2apgl3kaqghq"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.completion"))
    (home-page "https://github.com/nvim-mini/mini.completion")
    (synopsis "Autocompletion and signature help plugin")
    (description "Autocompletion and signature help plugin.")
    (license license:expat)))

(define-public mini-diff
  (package
    (name "neovim-mini.diff")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.diff")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "10qjb1w9ymyws0k8jdngckad5apj02dpm5i5aldi6mgf1i6aq436"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.diff"))
    (home-page "https://github.com/nvim-mini/mini.diff")
    (synopsis "Work with diff hunks")
    (description "Neovim pluging to help working with diff and hunks.")
    (license license:expat)))

(define-public mini-extra
  (package
    (name "neovim-mini.extra")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.extra")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vbww19ynr3j9wmdxgcilpmw72bs6ij6prmdnah1az8ps0xknc22"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.extra"))
    (home-page "https://nvim-mini.org/mini.nvim/doc/mini-extra.html")
    (synopsis "Extra 'mini.nvim' functionality")
    (description "Extra useful functionality which is not essential enough for other ‘mini.nvim’ modules to include directly.")
    (license license:expat)))

(define-public mini-files
  (package
    (name "neovim-mini.files")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.files")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0zwnslrdykxbg8zbrzq9k3mpwppsilxjpsrq93kqwbs98y8g8426"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.files"))
    (home-page "https://github.com/nvim-mini/mini.files")
    (synopsis "Navigate and manipulate file system")
    (description
     "Neovim pluing that allows Navigation and manipulation of the file system.")
    (license license:expat)))

(define-public mini-git
  (package
    (name "neovim-mini.git")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini-git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1741ddw3nwi8ihx0wl9vcmc0g2g4kql8n1f9svmbp29m0n4z5vay"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.git"))
    (home-page "https://github.com/nvim-mini/mini-git")
    (synopsis "Navigate and manipulate file system")
    (description
     "Neovim pluing that allows Navigation and manipulation of the file system.")
    (license license:expat)))

(define-public mini-icons
  (package
    (name "neovim-mini.icons")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.icons")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1v384z5ll53j6q2rk9v7vaa79yhjky1lrinvi70g1hd7fil7zgif"))))
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
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.indentscope")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yqhz9m3nkq1pyk9l8jwqc3n6mvzdr3agjxf20lrrrwzvx8kn43a"))))
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
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.pick")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "06a726x2cz715hdvm74rl2ccx996h8lqwjc702fw6nj718wwgf3r"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.pick"))
    (home-page "https://github.com/nvim-mini/mini.pick")
    (synopsis "Navigate and manipulate file system")
    (description
     "Neovim pluing that allows Navigation and manipulation of the file system.")
    (license license:expat)))

(define-public mini-snippets
  (package
    (name "neovim-mini.snippets")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.snippets")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17l3k5bagjyz8i0bd5h5il9sy06wjh28c8ywcnqc0xc1s2lqd102"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.snippets"))
    (home-page "https://github.com/nvim-mini/mini.snippets")
    (synopsis
     "Manage and expand snippets")
    (description
     "Manage and expand snippets.")
    (license license:expat)))

(define-public mini-statusline
  (package
    (name "neovim-mini.statusline")
    (version "0.18.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.statusline")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0g3p3swdbq82xipdsxkvc6sa1ybyw14l513qm4zbm8vvf5xrnmq9"))))
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
    (synopsis
     "Extensions for the built-in Language Server Protocol support in Neovim (>= 0.6.0) for eclipse.jdt.ls.")
    (description
     "Extensions for the built-in Language Server Protocol support in Neovim (>= 0.6.0) for eclipse.jdt.ls.")
    (license license:expat)))

(define-public luasnip
  (package
    (name "neovim-luasnip")
    (version "2.5.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/L3MON4D3/LuaSnip")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "16cirbi0zjg874858yqd36p3kbrmlpfii3bvx6lm9bpli7b4w9kn"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "luasnip"))
    (home-page "https://github.com/L3MON4D3/LuaSnip")
    (synopsis "Snippets engine for Neovim")
    (description "Snipptes engine for Neovim")
    (license license:asl2.0)))

(define-public nvim-plenary
  (package
    (name "neovim-plenary")
    (version "2026-04-09")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-lua/plenary.nvim")
             (commit "74b06c6c75e4eeb3108ec01852001636d85a932b")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bms9ihcz2gsk88mr00izxn7sjl1lfc62mk0fy54z20g756c8iwy"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "plenary"))
    (home-page "https://github.com/nvim-lua/plenary.nvim")
    (synopsis "Neovim utilities.")
    (description "Neovim utilities.")
    (license license:asl2.0)))
