(define-module (am5k packages password-utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download)
  #:use-module (guix packages))

(define-public pass-update
  (package
    (name "pass-update")
    (version "2.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference 
							(url "https://github.com/roddhjav/pass-update")
							(commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1srg0zpgfj2rcsc8aynq7jy2wd9l2h21rpp73si6rwiccff4ymrl"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags
       (let* ((out      (assoc-ref %outputs "out"))
              (bashcomp (string-append out "/etc/bash_completion.d")))
         (list (string-append "PREFIX=" %output)
               (string-append "BASHCOMPDIR=" bashcomp)))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'check))
       #:test-target "test"))
    (home-page "https://github.com/roddhjav/pass-update")
    (synopsis "A pass extension that provides an easy flow for updating passwords.")
    (description
     "Pass update extends the pass utility with an update command providing an
		 easy flow for updating passwords. It supports path, directory and wildcard update.
		 Moreover, you can select how to update your passwords by automatically 
		 generating new passwords or manually setting your own.")
    (license license:gpl3+)))
