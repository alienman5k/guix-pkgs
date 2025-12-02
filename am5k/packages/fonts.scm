(define-module (am5k packages fonts)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system font))

(define-public font-aliensevka
  (package
    (name "font-aliensevka")
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/alienman5k/aliensevka/releases/download/v"
             version "/Aliensevka.zip"))
       (sha256
        (base32 "056ag5g1jk0mshifims3zpmp13sy6r4yhnpylmxnhrvbgn00bjim"))))
    (build-system font-build-system)
    (home-page "https://github.com/alienman5k/aliensevka")
    (synopsis "Aliensevka Font based on Iosevka")
    (description
     "This font is build using Iosevka, and customized inheriting from 
     Ubuntu Style. This way the font looks more rounded and easy to read
     for me while looking good for long working sessions.")
    (license license:silofl1.1)))
