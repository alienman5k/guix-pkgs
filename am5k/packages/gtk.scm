;; SPDX-FileCopyrightText: 2025 Murilo <murilo@disroot.org>
;;
;; SPDX-License-Identifier: GPL-3.0

(define-module (am5k packages gtk)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages)
  #:use-module (guix build-system meson)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:export (gtk4-layer-shell))

(define gtk4-layer-shell
  (package
    (name "gtk4-layer-shell")
    (version "1.1.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/wmww/gtk4-layer-shell")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "00z6y4z1m7yji1hff58m97k2f5zzmij67nh70dfz18vw5qmm0c75"))))
    (build-system meson-build-system)
    (arguments
      (list #:tests? #f
            #:configure-flags
            #~(list "-Ddocs=true"
                    "-Dexamples=true")))
    (native-inputs
      (list pkg-config
            gobject-introspection
            gtk-doc
            vala))
    (inputs
      (list gtk
            wayland
            wayland-protocols))
    (synopsis "A library to create panels and other desktop components for
Wayland using the Layer Shell protocol and GTK4")
    (description "A library for using the Layer Shell and Session Lock Wayland
protocols with GTK4. This Library is compatible with C, C++ and any language
that supports GObject introspection files (Python, Vala, etc).")
    (home-page "https://github.com/wmww/gtk4-layer-shell")
    (license license:expat)))
