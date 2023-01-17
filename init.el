;; These help with performance and TLS issues
(setq gc-cons-threshold 100000000) ;; 100MB
(setq gnutls-min-prime-bits 4096)

(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; start new windows maximized

(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))
