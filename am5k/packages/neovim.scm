(define-module (am5k packages neovim)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages vim))

(define-public nvim-0.11.3
  (package
    (inherit neovim)
    (name "neovim")
    (version "0.11.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neovim/neovim")
                    (commit "b2684d9f6658544d75e2431a06bcf21fe80673f8")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "07kg1wkv0dhxj8a1xfzj2dnwsp232vd16n1j6jyxs0vvcqqbg5jj"))))))



(define-public nvim-dev
  (package
    (inherit neovim)
    (name "neovim")
    (version "0.12.0-dev")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neovim/neovim")
                    (commit "58060c2340a52377a0e1d2b782ce1deef13b2b9b")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1c1zah52p93vqrw18fh5xppnrqrqb6xh8n4nzwi8nksrscgq8hqp"))))))
