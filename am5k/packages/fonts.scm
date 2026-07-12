(define-module (am5k packages fonts)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system font))

(define-public font-aliensevka
  (package
    (name "font-aliensevka")
    (version "1.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/alienman5k/aliensevka/releases/download/v"
             version "/Aliensevka.zip"))
       (sha256
        (base32 "1snd9jfagjkr027nnyqkm2b97c8xqdppalam22hlbli3fjxzhfqs"))))
    (build-system font-build-system)
    (home-page "https://github.com/alienman5k/aliensevka")
    (synopsis "Aliensevka Font based on Iosevka")
    (description
     "This font is build using Iosevka, and customized inheriting from 
     Ubuntu Style. This way the font looks more rounded and easy to read
     for me while looking good for long working sessions.")
    (license license:silofl1.1)))

(define-public font-bersevka
  (package
    (name "font-bersevka")
    (version "1.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/alienman5k/Bersevka/releases/download/v"
             version "/Bersevka.zip"))
       (sha256
        (base32 "088x2zxylh26wxm18kp9wnnzpyyndb40ljdnlikj43acfmlf0xg8"))))
    (build-system font-build-system)
    (home-page "https://github.com/alienman5k/Bersevka")
    (synopsis "Bersevka Font based on Iosevka")
    (description
     "This font is build using Iosevka, and customized to have a similar look
		 to Berkeley Mono. This way the font looks more rounded and easy to read
     for me while looking good for long working sessions.")
    (license license:silofl1.1)))
