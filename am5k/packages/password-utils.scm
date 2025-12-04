(define-module (am5k packages password-utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages version-control))

;; Returns a *file‑like* object (a `local-file`) containing a patch.
(define (pass-audit-patch-001)
	(plain-file "pass-audit-001.patch"
							"diff --git a/setup.py b/setup.py
index 1f0a58b..f7baa41 100644
--- a/setup.py
+++ b/setup.py
@@ -8,21 +8,8 @@ from pathlib import Path
 
 from setuptools import setup
 
-share = Path(sys.prefix, 'share')
-base = '/usr'
-if os.uname().sysname == 'Darwin':
-    base = '/usr/local'
-lib = Path(base, 'lib', 'password-store', 'extensions')
-
-if '--user' in sys.argv:
-    if 'PASSWORD_STORE_EXTENSIONS_DIR' in os.environ:
-        lib = Path(os.environ['PASSWORD_STORE_EXTENSIONS_DIR'])
-    else:
-        lib = Path.home() / '.password-store' / '.extensions'
-    if 'XDG_DATA_HOME' in os.environ:
-        share = Path(os.environ['XDG_DATA_HOME'])
-    else:
-        share = Path.home() / '.local' / 'share'
+share = Path('share')
+lib = Path('lib', 'password-store', 'extensions')
 
 setup(
     data_files=["))

(define (pass-audit-patch-002)
	(plain-file "pass-audit-002.patch"
						  "diff --git a/audit.bash b/audit.bash
index 7a973dc..c40ff76 100755
--- a/audit.bash
+++ b/audit.bash
@@ -17,7 +17,7 @@
 #
 
 cmd_audit() {
-	export PASSWORD_STORE_DIR=$PREFIX GIT_DIR PASSWORD_STORE_GPG_OPTS
+	export PASSWORD_STORE_DIR=${PASSWORD_STORE_DIR:-$HOME/.password-store} GIT_DIR PASSWORD_STORE_GPG_OPTS
 	export X_SELECTION CLIP_TIME PASSWORD_STORE_UMASK GENERATED_LENGTH
 	export CHARACTER_SET CHARACTER_SET_NO_SYMBOLS EXTENSIONS PASSWORD_STORE_KEY
 	export PASSWORD_STORE_ENABLE_EXTENSIONS PASSWORD_STORE_SIGNING_KEY
"))

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
			 (patches (list (pass-audit-patch-001) 
											(pass-audit-patch-002)))))
			 ; (patches (list 
			 ; 					(local-file "../packages/patches/pass-audit-001.patch")
			 ; 					(local-file "../packages/patches/pass-audit-002.patch")))
			 ; (patches (search-patches
			 ; 					"pass-audit-001.patch"
			 ; 					"pass-audit-002.patch"))
			 ; (patches (list (generated-patch-gexp)))
    (build-system python-build-system)
		(arguments
			(list
				#:tests? #f))
    (native-inputs (list password-store))
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
