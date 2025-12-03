(define-module (am5k packages password-utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages version-control))

(define-public pass-audit
  (package
    (name "pass-audit")
    (version "1.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/roddhjav/pass-audit")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yz2bmbvfli1xgw6na4ksha2ian7aqwdgxkm2z5q8p2ipkq0ya66"))
			 (patches (list "am5k/patches/pass-audit/001-set-base-to-an-empty-value.patch" "am5k/patches/pass-audit/002-fix-audit.bash-setup.patch"))))
    (build-system python-build-system)
		(arguments
			(list
				#:tests? #f))
    (native-inputs (list password-store git))
    (inputs (list python-requests python-zxcvbn))
    (home-page "https://github.com/roddhjav/pass-audit")
    (synopsis "Extension to @code{password-store} for auditing passwords")
    (description
     "@code{pass-audit} is a @code{password-store} extension for auditing your
password repository.  Passwords will be checked against the Python 
implementation of Dropbox' zxcvbn algorithm and Troy Hunt's Have I Been Pwned
Service.  It supports safe breached password detection from haveibeenpwned.com
using a K-anonymity method. Using this method, you do not need to (fully)
trust the server that stores the breached password. You should read the
security consideration section for more information.")
    (license license:gpl3)))
