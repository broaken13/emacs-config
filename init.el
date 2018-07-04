(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    which-key
    helm
    magit
    company
    company-quickhelp
    ace-window
    multiple-cursors
    smartparens
    elpy
    flycheck
    py-autopep8
    htmlize
    impatient-mode
    emmet-mode
    web-mode
    js2-mode
    js2-refactor
    xref-js2
    company-tern
    material-theme
    yoshi-theme
    typescript-mode
    tide
    omnisharp
    ))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-refresh-contents)
	    (package-install package)))
      myPackages)


;; Basic Customization
(require 'better-defaults)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(company-quickhelp-mode)

(global-set-key (kbd "C-x g") 'magit-status)

(global-set-key (kbd "M-o") 'ace-window)

(require 'smartparens-config)
(smartparens-global-mode 1)

(which-key-mode)

;; Does not work currently
(require 'multiple-cursors)
(global-set-key (kbd "C-x a C-n") 'mc/mark-next-like-this)
(global-set-key (kbd "C-x a C-p") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-x a M-f") 'mc/mark-next-like-this-word)
(global-set-key (kbd "C-x a M-b") 'mc/mark-previous-like-this-word)
(global-set-key (kbd "C-x a C-s") 'mc/mark-all-symbols-like-this)

;; Helm config
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") 'helm-select-action)

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p t
      helm-M-x-fuzzy-match t
      helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)

;; Python
(elpy-enable)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)


;; JavaScript
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(require 'js2-refactor)
(require 'xref-js2)
(require 'company-tern)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
    (add-hook 'xref-backend-functions #'xref-js2-backend nil t)))

(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook (lambda () (tern-mode)))


;; Disable completion keybindings, as we use xref-js2 instead
(define-key tern-mode-keymap (kbd "M-.") nil)
(define-key tern-mode-keymap (kbd "M-,") nil)

;; HTML/CSS
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))

;; Typescript
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1))

(setq company-tooltip-align-annotations t)

(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)


;; C# coding


(eval-after-load
    'company
  '(add-to-list 'company-backends 'company-omnisharp))

(defun csharp-programming-setup ()
  "My csharp programming setup"
  (omnisharp-mode)
  (flycheck-mode)
  
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile)
  )

(add-hook 'csharp-mode-hook 'csharp-programming-setup)
;;(setq inhibit-startup-message t) ;; hide startup message
(load-theme 'yoshi t) ;; load theme
(global-linum-mode t) ;; line numbers global
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-quickhelp-color-background "midnight blue")
 '(company-quickhelp-color-foreground "light gray")
 '(package-selected-packages (quote (material-theme better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
