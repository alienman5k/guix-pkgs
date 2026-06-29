;;; Copyright © 2024 Murilo <murilo@disroot.org>
;;;
;;; This file is NOT part of GNU Guix.

(define-module (am5k packages terminals)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages image)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages textutils)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages zig)
	#:use-module (guix build-system trivial)
  #:use-module (guix build-system zig)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (am5k packages gtk)
  #:export (ghostty ghostty-latest ghostty-terminfo))

(define ghostty
  (package
    (name "ghostty")
    (version "1.1.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ghostty-org/ghostty")
             (commit "9d9d781a0b7142ddc176167ef5e889618d295ef5")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1pl05qdwcrqf1fil0siqr4p2nvx14p0qld691n55qhii9blbi4c8"))))
    (build-system zig-build-system)
    (arguments
     (list
      #:tests? #f
      #:zig zig-0.14
      #:install-source? #f
      #:zig-release-type "fast"
      #:zig-build-flags
      #~(list "-Dcpu=baseline"
              "-Drenderer=opengl"
              "--prefix"
              "."
              "--system"
              (string-append (getenv "TMPDIR") "/source/zig-cache")
              "--search-prefix"
              #$(this-package-input "libadwaita")
              "--search-prefix"
              #$(this-package-input "gtk4-layer-shell")
              "--search-prefix"
              (string-append (getenv "TMPDIR") "/source/bzip2")
              "-fno-sys=oniguruma")
      #:modules '((guix build zig-build-system)
                  (guix build utils)
                  (ice-9 match))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'unpack-dependencies
            (lambda _
              (mkdir-p "bzip2/lib")
              (symlink (string-append #$(this-package-input "bzip2")
                                      "/lib/libbz2.so")
                       "bzip2/lib/libbzip2.so")))
          (add-after 'unpack 'unpack-zig
            (lambda _
              (for-each (match-lambda
                          ((dst src)
                           (let* ((dest (string-append "zig-cache/" dst)))
                             (mkdir-p dest)
                             (cond
                               ((string-contains src ".tar.gz")
                                (invoke "tar"
                                        "-xf"
                                        src
                                        "-C"
                                        dest
                                        "--strip-components=1"))
                               ((string-contains src ".tar.xz")
                                (invoke "tar"
                                        "-xf"
                                        src
                                        "-C"
                                        dest
                                        "--strip-components=1"))
                               ((string-contains src ".tar.zst")
                                (invoke "tar"
                                        "-xf"
                                        src
                                        "-C"
                                        dest
                                        "--strip-components=1"))
                               (else (copy-recursively src dest))))))
                        `(("N-V-__8AAB0eQwD-0MdOEBmz7intriBReIsIDNlukNVoNu6o" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/zlib-1220fed0c74e1019b3ee29edae2051788b080cd96e90d56836eea857b0b966742efb.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "0p6h2i9ajdp46lckdpibfqy4vz5nh5r22bqq96mp41k0ydiqis0p"))))
                          ("ziglyph-0.11.2-AAAAAHPtHwB4Mbzn1KvOV7Wpjo82NYEc_v0WC8oCLrkf" #$(origin

                                                                                             (method
                                                                                              url-fetch)

                                                                                             (uri
                                                                                              "https://deps.files.ghostty.org/ziglyph-b89d43d1e3fb01b6074bc1f7fc980324b04d26a5.tar.gz")

                                                                                             (sha256
                                                                                              (base32
                                                                                               "1ngkyc81gqqfkgccxx4hj4w4kb3xk0ng7z73bwihbwbdw7rvvivj"))))
                          ("zigimg-0.1.0-lly-O6N2EABOxke8dqyzCwhtUCAafqP35zC7wsZ4Ddxj" #$(origin

                                                                                           (method
                                                                                            git-fetch)

                                                                                           (uri
                                                                                            (git-reference
                                                                                             (url
                                                                                              "https://github.com/TUSF/zigimg")

                                                                                             (commit
                                                                                              "31268548fe3276c0e95f318a6c0d2ab10565b58d")))

                                                                                           (file-name
                                                                                            "zigimg")

                                                                                           (sha256
                                                                                            (base32
                                                                                             "1pf0rbyrrxq02dvkxfa9sba1f18bycdgvs2js2mfmkj8c6pmzfd1"))))
                          ("wayland-0.4.0-dev-lQa1kjfIAQCmhhQu3xF0KH-94-TzeMXOqfnP0-Dg6Wyy" #$(origin

                                                                                                (method
                                                                                                 url-fetch)

                                                                                                (uri
                                                                                                 "https://codeberg.org/ifreund/zig-wayland/archive/f3c5d503e540ada8cbcb056420de240af0c094f7.tar.gz")

                                                                                                (sha256
                                                                                                 (base32
                                                                                                  "06ajicqccha3ha1csv854kzbvqgicbi9mcsm7gdqcga0brkwdghk"))))
                          ("zig_objc-0.0.0-Ir_Sp3TyAADEVRTxXlScq3t_uKAM91MYNerZkHfbD0yt" #$(origin

                                                                                             (method
                                                                                              url-fetch)

                                                                                             (uri
                                                                                              "https://github.com/mitchellh/zig-objc/archive/3ab0d37c7d6b933d6ded1b3a35b6b60f05590a98.tar.gz")

                                                                                             (sha256
                                                                                              (base32
                                                                                               "0z1mncqyq7nivs5f8xbwfj5hsblyhvgxw2c5dgjn0jk1mi3nszff"))))
                          ("N-V-__8AAB9YCQBaZtQjJZVndk-g_GDIK-NTZcIa63bFp9yZ" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/zig_js-12205a66d423259567764fa0fc60c82be35365c21aeb76c5a7dc99698401f4f6fefc.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "0gaqqfb125pj62c05z2cpzih0gcm3482cfln50d41xf2aq4mw8vz"))))
                          ("zg-0.13.4-AAAAAGiZ7QLz4pvECFa_wG4O4TP4FLABHHbemH2KakWM" #$(origin

                                                                                        (method
                                                                                         git-fetch)

                                                                                        (uri
                                                                                         (git-reference
                                                                                          (url
                                                                                           "https://codeberg.org/atman/zg")

                                                                                          (commit
                                                                                           "4a002763419a34d61dcbb1f415821b83b9bf8ddc")))

                                                                                        (file-name
                                                                                         "zg")

                                                                                        (sha256
                                                                                         (base32
                                                                                          "006nxw79n49j43vrxv0dmfql3afds1llq9fil7hbzbp4r3lyb3by"))))
                          ("zf-0.10.3-OIRy8aiIAACLrBllz0zjxaH0aOe5oNm3KtEMyCntST-9" #$(origin

                                                                                        (method
                                                                                         url-fetch)

                                                                                        (uri
                                                                                         "https://github.com/natecraddock/zf/archive/7aacbe6d155d64d15937ca95ca6c014905eb531f.tar.gz")

                                                                                        (sha256
                                                                                         (base32
                                                                                          "1chbgj8d9wxdzsbq7c2d4hvqsn02y22jb5x7lmwbdqkz0wssayyy"))))
                          ("z2d-0.6.0-j5P_HvLdCABu-dXpCeRM7Uk4m16vULg1980lMNCQj4_C" #$(origin

                                                                                        (method
                                                                                         url-fetch)

                                                                                        (uri
                                                                                         "https://github.com/vancluever/z2d/archive/1e89605a624940c310c7a1d81b46a7c5c05919e3.tar.gz")

                                                                                        (sha256
                                                                                         (base32
                                                                                          "0x7hlz067j1b8qalkbv09birw55ql9j3si981xdy9dbs8r4rahiw"))))
                          ("N-V-__8AAAzZywE3s51XfsLbP9eyEw57ae9swYB9aGB6fCMs" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/wuffs-122037b39d577ec2db3fd7b2130e7b69ef6cc1807d68607a7c232c958315d381b5cd.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "04qwpr8c4xjla4skwb1fpvkjc0c611qhbhz9xp3c9rlnpq5d4k4y"))))
                          ("N-V-__8AAKw-DAAaV8bOAAGqA0-oD7o-HNIlPFYKRXSPT03S" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/wayland-protocols-258d8f88f2c8c25a830c6316f87d23ce1a0f12d9.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "1y1h0pmql53x6ixbsycgkzxlxsxqs9fkps754c7ycx8vx3fwmvaw"))))
                          ("N-V-__8AAKrHGAAs2shYq8UkE6bGcR1QJtLTyOE_lcosMn6t" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/wayland-9cb3d7aa9dc995ffafdbdef7ab86a949d0fb0e7d.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "03f574n5w0y6glr7lf8xjd71844qh8kxxb1s3zjpfxj3ivb92hga"))))
                          ("vaxis-0.1.0-BWNV_FUICQAFZnTCL11TUvnUr1Y0_ZdqtXHhd51d76Rn" #$(origin

                                                                                          (method
                                                                                           git-fetch)

                                                                                          (uri
                                                                                           (git-reference
                                                                                            (url
                                                                                             "https://github.com/rockorager/libvaxis")

                                                                                            (commit
                                                                                             "1f41c121e8fc153d9ce8c6eb64b2bbab68ad7d23")))

                                                                                          (file-name
                                                                                           "vaxis")

                                                                                          (sha256
                                                                                           (base32
                                                                                            "0xihpzj37mhpzxjrfy20z651vxqrqsgkr9iqhv1g7slkyyi7gmkc"))))
                          ("N-V-__8AAHffAgDU0YQmynL8K35WzkcnMUmBVQHQ0jlcKpjH" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/utfcpp-1220d4d18426ca72fc2b7e56ce47273149815501d0d2395c2a98c726b31ba931e641.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "1ksrdf7dy4csazhddi64xahks8jzf4r8phgkjg9hfxp722iniipz"))))
                          ("N-V-__8AANb6pwD7O1WG6L5nvD_rNMvnSc9Cpg1ijSlTYywv" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/spirv_cross-1220fb3b5586e8be67bc3feb34cbe749cf42a60d628d2953632c2f8141302748c8da.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "1qspcsx56v0mddarb6f05i748wsl2ln3d8863ydsczsyqk7nyaxm"))))
                          ("N-V-__8AAPlZGwBEa-gxrcypGBZ2R8Bse4JYSfo_ul8i2jlG" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/sentry-1220446be831adcca918167647c06c7b825849fa3fba5f22da394667974537a9c77e.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "1pqqqcin8nw398rvn187dfqlab4vikdssiry14qqs6nnr1y4kiia"))))
                          ("N-V-__8AAKYZBAB-CFHBKs3u4JkeiT4BMvyHu3Y5aaWF3Bbs" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/plasma_wayland_protocols-12207e0851c12acdeee0991e893e0132fc87bb763969a585dc16ecca33e88334c566.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "0hgl1p173pxs50z1p6mjjzcqssn44aq0ip166k56p3nd98hvln2w"))))
                          ("N-V-__8AADYiAAB_80AWnH1AxXC0tql9thT-R-DYO1gBqTLc" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/pixels-12207ff340169c7d40c570b4b6a97db614fe47e0d83b5801a932dcd44917424c8806.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "06pi3f3lhyxfzczhwrc2b4n0jhhzydbz96qlpw12a24is0b3ps2m"))))
                          ("N-V-__8AAHjwMQDBXnLq3Q2QhaivE0kE2aD138vtX2Bq1g7c" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/oniguruma-1220c15e72eadd0d9085a8af134904d9a0f5dfcbed5f606ad60edc60ebeccd9706bb.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "187jk4fxdkzc0wrcx4kdy4v6p1snwmv8r97i1d68yi3q5qha26h0"))))
                          ("N-V-__8AAG3RoQEyRC2Vw7Qoro5SYBf62IHn3HjqtNVY6aWK" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/libxml2-2.11.5.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "05b2kbccbkb5pkizwx2s170lcqvaj7iqjr5injsl5sry5sg0aa3c"))))
                          ("libxev-0.0.0-86vtc-ziEgDbLP0vihUn1MhsxNKY4GJEga6BEr7oyHpz" #$(origin

                                                                                           (method
                                                                                            url-fetch)

                                                                                           (uri
                                                                                            "https://github.com/mitchellh/libxev/archive/3df9337a9e84450a58a2c4af434ec1a036f7b494.tar.gz")

                                                                                           (sha256
                                                                                            (base32
                                                                                             "12k35sa7ll3rasw92ys4grzcaz8kj2asiv7ilzkk3xkvsw1nm9m0"))))
                          ("N-V-__8AAJrvXQCqAT8Mg9o_tk6m0yf5Fz-gCNEOKLyTSerD" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/libpng-1220aa013f0c83da3fb64ea6d327f9173fa008d10e28bc9349eac3463457723b1c66.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "0fm0y7543w2gx5sz3zg9i46x1am51c77a554r0zqwpphdjs9bk7y"))))
                          ("N-V-__8AAEH8MwQaEsARbyV42-bSZGcu1am8xtg2h67wTFC3" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://github.com/mbadolato/iTerm2-Color-Schemes/archive/4c57d8c11d352a4aeda6928b65d78794c28883a5.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "0ddj389h2s4w0khf91rnskbsq61gjxqrdn22d51kv2qg86z71svk"))))
                          ("N-V-__8AAH0GaQC8a52s6vfIxg88OZgFgEW6DFxfSK4lX_l3" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/imgui-1220bc6b9daceaf7c8c60f3c3998058045ba0c5c5f48ae255ff97776d9cd8bfc6402.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "0q3qxycyl0z64mxf5j24c0g0yhif3mi7qf183rwan4fg0hgd0px0"))))
                          ("N-V-__8AAGmZhABbsPJLfbqrh6JTHsXhY6qCaLAQyx25e0XE" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/highway-66486a10623fa0d72fe91260f96c892e41aceb06.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "04m21b46h6c4x099r9qb720ql9llpzz8yq3k94i8zq7l7s4zim47"))))
                          ("N-V-__8AAG02ugUcWec-Ndp-i7JTsJ0dgF8nnJRUInkGLG7G" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/harfbuzz-11.0.0.tar.xz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "16rb7aazy36pj3xrjy149dd90j9yv7q5jnqx5kz2air1zsx52qzi"))))
                          ("N-V-__8AALiNBAA-_0gprYr92CjrMj1I5bqNu0TSJOnjFNSr" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/gtk4-layer-shell-1.1.0.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "12396gx723ybgq1xp9i02257hsmzqhb5z9b39xdyypha4s0l4a4q"))))
                          ("gobject-0.2.0-Skun7IWDlQAOKu4BV7LapIxL9Imbq1JRmzvcIkazvAxR" #$(origin

                                                                                            (method
                                                                                             url-fetch)

                                                                                            (uri
                                                                                             "https://github.com/jcollie/ghostty-gobject/releases/download/0.14.0-2025-03-18-21-1/ghostty-gobject-0.14.0-2025-03-18-21-1.tar.zst")

                                                                                            (sha256
                                                                                             (base32
                                                                                              "1clqi8glm65ylx4fv5fy5j2cy5d393jyyn749yfprpcx8nbjjrw5"))))
                          ("N-V-__8AABzkUgISeKGgXAzgtutgJsZc0-kkeqBBscJgMkvy" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/glslang-12201278a1a05c0ce0b6eb6026c65cd3e9247aa041b1c260324bf29cee559dd23ba1.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "1dcpm70fhxk07vk37f5l0hb9gxfv6pjgbqskk8dfbcwwa2xyv8hl"))))
                          ("N-V-__8AAMrJSwAUGb9-vTzkNR-5LXS81MR__ZRVfF3tWgG6" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://github.com/glfw/glfw/archive/e7ea71be039836da3a98cea55ae5569cb5eb885c.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "02i91dn556qhb4mafybs0rgcl633plpkzxcmlg0ycc9581fpawrk"))))
                          ("N-V-__8AADcZkgn4cMhTUpIz6mShCKyqqB-NBtf_S2bHaTC-" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/gettext-0.24.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "1dqq2ln01mfwr4gblvy0cyvarbqnv09ml5sdhksdlw1xb4ym0669"))))
                          ("N-V-__8AAKLKpwC4H27Ps_0iL3bPkQb-z6ZVSrB-x_3EEkub" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/freetype-1220b81f6ecfb3fd222f76cf9106fecfa6554ab07ec7fdc4124b9bb063ae2adf969d.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "035r5bypzapa1x7za7lpvpkz58fxynz4anqzbk8705hmspsh2wj2"))))
                          ("N-V-__8AAIrfdwARSa-zMmxWwFuwpXf1T3asIN7s5jqi9c1v" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/fontconfig-2.14.2.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "0mcarq6v9k7k9a8is23vq9as0niv0hbagwdabknaq6472n9dv8iv"))))
                          ("N-V-__8AALw2uwF_03u4JRkZwRLc3Y9hakkYV7NKRR9-RIZJ" #$(origin

                                                                                  (method
                                                                                   url-fetch)

                                                                                  (uri
                                                                                   "https://deps.files.ghostty.org/breakpad-b99f444ba5f6b98cac261cbb391d8766b34a5918.tar.gz")

                                                                                  (sha256
                                                                                   (base32
                                                                                    "1nbadlml3r982bz1wyp17w33hngzkb07f47nrrk0g68s7na9ijkc")))))))))))
    (native-inputs (list `(,glib "bin")
                         blueprint-compiler
                         gnu-gettext
                         gobject-introspection
                         ncurses
                         pandoc
                         pkg-config
                         tar))
    (inputs (list bzip2
                  expat
                  fontconfig
                  freetype
                  glslang
                  gtk4-layer-shell
                  harfbuzz
                  libadwaita
                  libglvnd
                  libpng
                  libx11
                  libxcursor
                  libxi
                  libxrandr
                  zlib))
    (native-search-paths
     ;; FIXME: This should only be located in 'ncurses'.  Nonetheless it is
     ;; provided for usability reasons.  See <https://bugs.gnu.org/22138>.
     (list (search-path-specification
            (variable "TERMINFO_DIRS")
            (files '("share/terminfo")))))
    (synopsis
     "Fast, native, feature-rich terminal emulator pushing modern features")
    (description
     "Ghostty is a terminal emulator that differentiates itself by
being fast, feature-rich, and native. While there are many excellent terminal
emulators available, they all force you to choose between speed, features, or
native UIs. Ghostty provides all three.")
    (home-page "https://ghostty.org")
    (license license:expat)))

(define ghostty-latest
 (package
  (inherit ghostty)
  (name "ghostty")
  (version "latest")
  (source (origin
            (method git-fetch)
            (uri (git-reference
                   (url "https://github.com/ghostty-org/ghostty")
                   (commit "6ceaa34a7c8d0d4c855053261bdd2a5f75809984")))
            (file-name (git-file-name name version))
            (sha256
             (base32 "0mg2xwba4nczz7386nx2yyf0ry5b9jcvz4vplm82pf1dpasxa7hs"))))
 ))

(define ghostty-terminfo
  (package
    (name "ghostty-terminfo")
    (version "1.0.0")
    (source #f)
    (build-system trivial-build-system)
    (arguments
     (list
      #:modules '((guix build utils))
      #:builder
      #~(begin
          (use-modules (guix build utils))
          (let* ((out (assoc-ref %outputs "out"))
                 (tic (string-append #$(this-package-native-input "ncurses") "/bin/tic"))
                 (terminfo-dir (string-append out "/share/terminfo"))
                 (src-file "ghostty.ti"))
            
            (mkdir-p terminfo-dir)
            
            ;; Write the raw Ghostty terminfo source definitions
            (with-output-to-file src-file
              (lambda ()
                (display "
xterm-ghostty|ghostty|Ghostty,
        am, bce, ccc, hs, km, mc5i, mir, msgr, npc, xenl, AX, Su, Tc, XT, fullkbd,
        colors#256, cols#80, it#8, lines#24, pairs#32767,
        acsc=++\,\,--..00``aaffgghhiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~,
        bel=^G, blink=\E[5m, bold=\E[1m, cbt=\E[Z, civis=\E[?25l,
        clear=\E[H\E[2J, cnorm=\E[?12l\E[?25h, cr=^M,
        csr=\E[%i%p1%d;%p2%dr, cub=\E[%p1%dD, cub1=^H,
        cud=\E[%p1%dB, cud1=^J, cuf=\E[%p1%dC, cuf1=\E[C,
        cup=\E[%i%p1%d;%p2%dH, cuu=\E[%p1%dA, cuu1=\E[A,
        cvvis=\E[?12;25h, dch=\E[%p1%dP, dch1=\E[P, dim=\E[2m,
        dl=\E[%p1%dM, dl1=\E[M, dsl=\E]2;\007, ech=\E[%p1%dX,
        ed=\E[J, el=\E[K, el1=\E[1K, flash=\E[?5h$<100/>\E[?5l,
        fsl=^G, home=\E[H, hpa=\E[%i%p1%dG, ht=^I, hts=\EH,
        ich=\E[%p1%d@, ich1=\E[@, il=\E[%p1%dL, il1=\E[L, ind=^J,
        indn=\E[%p1%dS,
        initc=\E]4;%p1%d;rgb\:%p2%{255}%*%{1000}%/%2.2X/%p3%{255}%*%{1000}%/%2.2X/%p4%{255}%*%{1000}%/%2.2X\E\\,
        invis=\E[8m, kDC=\E[3;2~, kEND=\E[1;2F, kHOM=\E[1;2H,
        kIC=\E[2;2~, kLFT=\E[1;2D, kNXT=\E[6;2~, kPRV=\E[5;2~,
        kRIT=\E[1;2C, kbs=\177, kcbt=\E[Z, kcub1=\EOD, kcud1=\EOB,
        kcuf1=\EOC, kcuu1=\EOA, kdch1=\E[3~, kend=\EOF, kent=\EOM,
        kf1=\EOP, kf10=\E[21~, kf11=\E[23~, kf12=\E[24~,
        kf13=\E[1;2P, kf14=\E[1;2Q, kf15=\E[1;2R, kf16=\E[1;2S,
        kf17=\E[15;2~, kf18=\E[17;2~, kf19=\E[18;2~, kf2=\EOQ,
        kf20=\E[19;2~, kf21=\E[20;2~, kf22=\E[21;2~,
        kf23=\E[23;2~, kf24=\E[24;2~, kf25=\E[1;5P, kf26=\E[1;5Q,
        kf27=\E[1;5R, kf28=\E[1;5S, kf29=\E[15;5~, kf3=\EOR,
        kf30=\E[17;5~, kf31=\E[18;5~, kf32=\E[19;5~,
        kf33=\E[20;5~, kf34=\E[21;5~, kf35=\E[23;5~,
        kf36=\E[24;5~, kf37=\E[1;6P, kf38=\E[1;6Q, kf39=\E[1;6R,
        kf4=\EOS, kf40=\E[1;6S, kf41=\E[15;6~, kf42=\E[17;6~,
        kf43=\E[18;6~, kf44=\E[19;6~, kf45=\E[20;6~,
        kf46=\E[21;6~, kf47=\E[23;6~, kf48=\E[24;6~,
        kf49=\E[1;3P, kf5=\E[15~, kf50=\E[1;3Q, kf51=\E[1;3R,
        kf52=\E[1;3S, kf53=\E[15;3~, kf54=\E[17;3~,
        kf55=\E[18;3~, kf56=\E[19;3~, kf57=\E[20;3~,
        kf58=\E[21;3~, kf59=\E[23;3~, kf6=\E[17~, kf60=\E[24;3~,
        kf61=\E[1;4P, kf62=\E[1;4Q, kf63=\E[1;4R, kf7=\E[18~,
        kf8=\E[19~, kf9=\E[20~, khome=\EOH, kich1=\E[2~,
        kind=\E[1;2B, kmous=\E[<, knp=\E[6~, kpp=\E[5~,
        kri=\E[1;2A, oc=\E]104\007, op=\E[39;49m, rc=\E8,
        rep=%p1%c\E[%p2%{1}%-%db, rev=\E[7m, ri=\EM,
        rin=\E[%p1%dT, ritm=\E[23m, rmacs=\E(B, rmam=\E[?7l,
        rmcup=\E[?1049l, rmir=\E[4l, rmkx=\E[?1l\E>, rmso=\E[27m,
        rmul=\E[24m, rs1=\E]\E\\\Ec, sc=\E7,
        setab=\E[%?%p1%{8}%<%t4%p1%d%e%p1%{16}%<%t10%p1%{8}%-%d%e48;5;%p1%d%;m,
        setaf=\E[%?%p1%{8}%<%t3%p1%d%e%p1%{16}%<%t9%p1%{8}%-%d%e38;5;%p1%d%;m,
        sgr=%?%p9%t\E(0%e\E(B%;\E[0%?%p6%t;1%;%?%p5%t;2%;%?%p2%t;4%;%?%p1%p3%|%t;7%;%?%p4%t;5%;%?%p7%t;8%;m,
        sgr0=\E(B\E[m, sitm=\E[3m, smacs=\E(0, smam=\E[?7h,
        smcup=\E[?1049h, smir=\E[4h, smkx=\E[?1h\E=, smso=\E[7m,
        smul=\E[4m, tbc=\E[3g, tsl=\E]2;, u6=\E[%i%d;%dR, u7=\E[6n,
        u8=\E[?%[;0123456789]c, u9=\E[c, vpa=\E[%i%p1%dd,
        BD=\E[?2004l, BE=\E[?2004h, Clmg=\E[s,
        Cmg=\E[%i%p1%d;%p2%ds, Dsmg=\E[?69l, E3=\E[3J,
        Enmg=\E[?69h, Ms=\E]52;%p1%s;%p2%s\007, PE=\E[201~,
        PS=\E[200~, RV=\E[>c, Se=\E[2 q,
        Setulc=\E[58\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&%d\:%p1%{255}%&%d%;m,
        Smulx=\E[4\:%p1%dm, Ss=\E[%p1%d q,
        Sync=\E[?2026%?%p1%{1}%-%tl%eh%;,
        XM=\E[?1006;1000%?%p1%{1}%=%th%el%;, XR=\E[>0q,
        fd=\E[?1004l, fe=\E[?1004h, kDC3=\E[3;3~, kDC4=\E[3;4~,
        kDC5=\E[3;5~, kDC6=\E[3;6~, kDC7=\E[3;7~, kDN=\E[1;2B,
        kDN3=\E[1;3B, kDN4=\E[1;4B, kDN5=\E[1;5B, kDN6=\E[1;6B,
        kDN7=\E[1;7B, kEND3=\E[1;3F, kEND4=\E[1;4F,
        kEND5=\E[1;5F, kEND6=\E[1;6F, kEND7=\E[1;7F,
        kHOM3=\E[1;3H, kHOM4=\E[1;4H, kHOM5=\E[1;5H,
        kHOM6=\E[1;6H, kHOM7=\E[1;7H, kIC3=\E[2;3~, kIC4=\E[2;4~,
        kIC5=\E[2;5~, kIC6=\E[2;6~, kIC7=\E[2;7~, kLFT3=\E[1;3D,
        kLFT4=\E[1;4D, kLFT5=\E[1;5D, kLFT6=\E[1;6D,
        kLFT7=\E[1;7D, kNXT3=\E[6;3~, kNXT4=\E[6;4~,
        kNXT5=\E[6;5~, kNXT6=\E[6;6~, kNXT7=\E[6;7~,
        kPRV3=\E[5;3~, kPRV4=\E[5;4~, kPRV5=\E[5;5~,
        kPRV6=\E[5;6~, kPRV7=\E[5;7~, kRIT3=\E[1;3C,
        kRIT4=\E[1;4C, kRIT5=\E[1;5C, kRIT6=\E[1;6C,
        kRIT7=\E[1;7C, kUP=\E[1;2A, kUP3=\E[1;3A, kUP4=\E[1;4A,
        kUP5=\E[1;5A, kUP6=\E[1;6A, kUP7=\E[1;7A, kxIN=\E[I,
        kxOUT=\E[O, rmxx=\E[29m, rv=\E\\[[0-9]+;[0-9]+;[0-9]+c,
        setrgbb=\E[48\:2\:%p1%d\:%p2%d\:%p3%dm,
        setrgbf=\E[38\:2\:%p1%d\:%p2%d\:%p3%dm, smxx=\E[9m,
        xm=\E[<%i%p3%d;%p1%d;%p2%d;%?%p4%tM%em%;,
        xr=\EP>\\|[ -~]+a\E\\,
")))
            
            ;; Compile the file using ncurses 'tic' directly into the output directory
            (invoke tic "-x" "-o" terminfo-dir src-file)))))
    (native-inputs (list ncurses))
    (synopsis "System-wide terminfo entry for the Ghostty terminal")
    (description "Provides xterm-ghostty capabilities database system-wide.")
    (home-page "https://ghostty.org")
    (license license:expat)))
