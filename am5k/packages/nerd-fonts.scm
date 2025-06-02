(define-module (nongnu packages nerd-fonts)
  #:use-module (ice-9 string-fun)
  #:use-module (gnu packages compression)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system font)
  #:use-module ((guix licenses)
                #:prefix license:))

(define nerd-fonts
  (lambda* (package-name #:key font-name file-name hash)
    (package
      ;; Downcase and replace " " with - to get "font-microsoft-times-new-roman"
      ;; from "Times New Roman"
      (name (string-append "font-nerd-fonts-" package-name))
      (version "3.2.1")
      (source
       (origin
         (method url-fetch)
         (uri (string-append "https://github.com/ryanoasis/nerd-fonts/releases/download/v" version "/" (if (not file-name) font-name file-name) ".tar.xz"))
         (sha256 (base32 hash))))
      (build-system font-build-system)
      (arguments
    `(#:phases
      (modify-phases %standard-phases
                     (add-before 'install 'make-files-writable
                                 (lambda _
                                   (for-each
                                     make-file-writable
                                     (find-files "." ".*\\.(otf|otc|ttf|ttc)$"))
                                   #t)))))
      (home-page "https://www.nerdfonts.com/")
      (synopsis (string-append "Nerd font variant of " font-name))
      (description (string-append
       "Nerd font variant of " font-name ".
Nerd Fonts is a project that patches developer targeted fonts with a high number of glyphs (icons).  
Specifically to add a high number of extra glyphs from popular 'iconic fonts' such as 
Font Awesome, Devicons, Octicons, and others."))
      (license license:silofl1.1))))

(define-public font-nerd-fonts-symbols
               (nerd-fonts "symbols"
                           #:font-name "Symbols Only"
                           #:file-name "NerdFontsSymbolsOnly"
                           #:hash "0y4r1rid5sjd9ihi6nkwy0sja792aghg21bpl3ri029b9pifx8xp"))

(define-public font-nerd-fonts-blex-mono
               (nerd-fonts "blex-mono"
                           #:font-name "IBM Plex Mono"
                           #:file-name "IBMPlexMono"
                           #:hash "0hd04z17l2p21hij4a0gmwnlfxs7s8qqh08zf4pzqld10557gqlp"))

(define-public font-nerd-fonts-fira-code
               (nerd-fonts "fira-code" 
                           #:font-name "Fira Code"
                           #:file-name "FiraCode" 
                           #:hash "1i1vw65f00n6vjinyqr1bq5ni5r6g8cjinrfl5zhlqm0gagv5x6y"))

(define-public font-nerd-fonts-fira-mono
               (nerd-fonts "jetbrains-mono" 
                           #:font-name "Fira Mono"
                           #:file-name "FiraMono" 
                           #:hash "1i9bfxblx568wsjq7ks1kyyfn9k36i4r2an4n45mb46swc94n8n0"))

(define-public font-nerd-fonts-hack
               (nerd-fonts "hack" 
                           #:font-name "Hack"
                           #:hash "1wxmd4jr4p11cfhzs5chyh649vps6sdz4bq28204npkd7wzh5fc9"))

(define-public font-nerd-fonts-iosevka
               (nerd-fonts "ioasevka" 
                           #:font-name "Iosevka"
                           #:hash "0dzkcn277jxiqrrqkyigw6jgd4lp9411r28rkpkwx6js6px27q8v"))

(define-public font-nerd-fonts-iosevka-term
               (nerd-fonts "ioasevka-term" 
                           #:font-name "Iosevka Term"
                           #:file-name "IosevkaTerm" 
                           #:hash "1xccqkydkhmhq8akk23kkypqzcc2svyicxv9gblwzwbndjrfgmdm"))

(define-public font-nerd-fonts-iosevka-term-slab
               (nerd-fonts "ioasevka-term-slab" 
                           #:font-name "Iosevka Term Slab"
                           #:file-name "IosevkaTermSlab" 
                           #:hash "1svig63li8mjj2dkgiawgb82gpk8vkrkhih5cp0a6174bh4gycii"))

(define-public font-nerd-fonts-jetbrains-mono
               (nerd-fonts "jetbrains-mono" 
                           #:font-name "JetBrains Mono"
                           #:file-name "JetBrainsMono" 
                           #:hash "01j0rkgrix7mdp9fx0y8zzk1kh40yfcp932p0r5y666aq4mq5y3c"))

