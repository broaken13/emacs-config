;; Set garbage collection threshold
(setq gc-cons-threshold 50000000)
;; Fixes some TLS warnings
(setq gnutls-min-prime-bits 4096)

(require 'package)
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;;;;;;;

(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))
