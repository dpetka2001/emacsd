(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))

;; use-package initialization
;; install use-package if not already done
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))
;; use-package for all others
(require 'use-package)

;; use-package verbose output
(setq use-package-verbose t)

;; Delight package to hide/abbreviate modes in modeline
(use-package delight
  :ensure t)

;; Set default dir and custom file
(setq default-directory "~/.emacs.d/")
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)

;; Dirs for local package install
(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

;; Don't show initial screen
(setq inhibit-startup-screen t)

;; Save session/buffers
(desktop-save-mode 1)

;; show line numbers
(global-linum-mode t)
(column-number-mode t)

;; you won't need any of the bar thingies
;; turn it off to save screen estate
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; set the file size indication to true
(size-indication-mode t)

(show-paren-mode 1)
(electric-pair-mode 1)

;; Number keys to open file lists
(recentf-mode 1)
(global-set-key (kbd "M-1") 'recentf-open-files)
(global-set-key (kbd "M-2") 'ibuffer)

;; Package to show number of window and switch to window according to number
(use-package window-number
  :ensure t
  :bind
    (("M-0" . window-number-switch)
      )
  :config
    (window-number-mode 1)
  )

;; y or n is enough
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'eb 'eval-buffer)
(defalias 'lp 'package-list-packages)

(use-package org
  :ensure t
  :bind (("C-c a" . org-agenda)
    )
  :config 
    (use-package org-tempo)
    (setq org-startup-folded nil)
    (setq org-indent-mode-turns-on-hiding-stars nil)
    (add-hook 'org-mode-hook 'org-indent-mode)
    (setq org-edit-src-content-indentation 3)
    (setq org-src-window-setup 'split-window-below)
    ;; Disable symbol's `<' pairing for electric pairing in org mode locally
    (add-hook 'org-mode-hook
       (lambda ()
         (setq-local electric-pair-inhibit-predicate
            `(lambda (c)
               (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c)))))
       )
  )

;; Package to move around lines/regions
(use-package move-lines
  :ensure nil
  :config
  (move-lines-binding)
  )

(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))

(use-package ivy
  :ensure t
  :defer 0.1
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package ivy-rich
  :ensure t
  :after ivy
  :custom
  (ivy-virtual-abbreviate 'full
                          ivy-rich-switch-buffer-align-virtual-buffer t
                          ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
  ("C-r" . swiper)))

(use-package benchmark-init
  :ensure t
  :config
  ;; disable collection of data after init is done
  (add-hook 'after-init-hook 'benchmark-init/deactivate)
  )

(use-package magit
  :ensure t
  :bind (("C-x g s" . magit-status))
  :config
  (set-default 'magit-stage-all-confirm nil)
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)

  ;; full screen magit-status
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))

  ;; (global-unset-key (kbd "C-x g"))
  ;; (global-set-key (kbd "C-x g h") 'magit-log)
  ;; (global-set-key (kbd "C-x g f") 'magit-file-log)
  ;; (global-set-key (kbd "C-x g b") 'magit-blame-mode)
  ;; (global-set-key (kbd "C-x g m") 'magit-branch-manager)
  ;; (global-set-key (kbd "C-x g c") 'magit-branch)
  ;; (global-set-key (kbd "C-x g s") 'magit-status)
  ;; (global-set-key (kbd "C-x g r") 'magit-reflog)
  ;; (global-set-key (kbd "C-x g t") 'magit-tag)
  )
