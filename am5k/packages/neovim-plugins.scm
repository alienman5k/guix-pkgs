(define-module (am5k packages neovim-plugins)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system vim)
  #:use-module (gnu packages vim)
  #:use-module (guix gexp))

(define-public mini
  (package
    (name "neovim-mini")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nvim-mini/mini.diff")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "12027xb9907zk145hsx6qniq1cjm8bm5405njq4cs9vx992pafsh"))))
    (build-system vim-build-system)
    (arguments
     (list
      #:plugin-name "mini.files"))
    (home-page "https://github.com/nvim-mini/mini.diff")
    (synopsis "Work with diff hunks")
    (description "Neovim pluing to help working with diff and hunks.")
    (license license:expat)))

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
      #:plugin-name "mini.diff"))
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
      #:plugin-name "mini.files"))
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
      #:plugin-name "mini.git"))
    (home-page "https://github.com/nvim-mini/mini-git")
    (synopsis "Navigate and manipulate file system")
    (description
     "Neovim pluing that allows Navigation and manipulation of the file system.")
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
