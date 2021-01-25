(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))

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
(if (eq system-type 'windows-nt)
    (progn 
      (setq default-directory "C:/Users/jrn23/AppData/Roaming/.emacs.d/")
      (setq custom-file "C:/Users/jrn23/AppData/Roaming/.emacs.d/emacs-custom.el")
      (setq user-emacs-directory "C:/Users/jrn23/AppData/Roaming/.emacs.d/"))
    )

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

;; You won't need any of the bar thingies,
;; turn it off to save screen estate
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; The blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; Set the file size indication to true
(size-indication-mode t)

;; Themes configuration
(when (display-graphic-p)
  (use-package abyss-theme
    :ensure t
    :config
    (load-theme #'abyss t)
    )
  (use-package color-theme-modern
    :ensure t)
  )

(show-paren-mode 1)
(electric-pair-mode 1)

;; Number keys to open file lists
(recentf-mode 1)
(global-set-key (kbd "M-1") 'recentf-open-files)
(global-set-key (kbd "M-2") 'ibuffer)

;; Package to show number of window and switch to window according to number
(use-package window-number
  :ensure t
  :commands window-number-switch
  :bind
    (("M-0" . window-number-switch)
      )
  ;; :config
  ;; (window-number-mode 1)
  )

;; y or n is enough
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'eb 'eval-buffer)
(defalias 'lp 'package-list-packages)

(use-package helpful
  :ensure t
  :bind
  (("C-h k" . helpful-key)
   ("C-h c" . helpful-command)
   ("C-x C-d" . helpful-at-point)
   )
  :config
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable)
  )

(use-package org
  :ensure t
  :bind (("C-c a" . org-agenda)
    )
  :config
    ;; Package required for expanding snippets to code block structures
    (use-package org-tempo)
    (setq org-startup-folded nil)
    (setq org-indent-mode-turns-on-hiding-stars nil)
    ;; Set the value to `nil', so that org does not load unnecessary modules that increase start up time
    (setq org-modules nil)
    (add-hook 'org-mode-hook 'org-indent-mode)
    ;; (delight 'org-indent-mode "" 'org-indent)
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
  :ensure nil           ;; Local package in `/lisp' directory
  :config
  (move-lines-binding)
  )

(use-package counsel
  :ensure t
  :delight
  :after ivy
  :config
  (counsel-mode)

  ;; Disable `describe-bindings' remap
  (define-key counsel-mode-map [remap describe-bindings] nil)

  ;; Install smex to use under the hood to display most recently used command history
  (use-package smex
    :ensure t
    )
  )

(use-package ivy
  :ensure t
  :delight
  :defer 0.1
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config
    (ivy-mode)
    ;; Disable counsel-M-x to start with "^"
    (setcdr (assoc 'counsel-M-x ivy-initial-inputs-alist) "")
  )

(use-package ivy-rich
  :hook (ivy-mode . ivy-rich-mode)
  :custom (ivy-rich-path-style 'abbrev)
  :config
  (ivy-rich-modify-columns
   'ivy-switch-buffer
   '((ivy-rich-switch-buffer-size (:align right))
     (ivy-rich-switch-buffer-major-mode (:width 20 :face error))))
  )

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
  ("C-r" . swiper)))

(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  ;;(add-hook 'after-init-hook 'benchmark-init/deactivate)
  )

(use-package company
  :ensure t
  :defer 0.5
  ;;:delight
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay 0)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  ;; Disable company-mode from running in ivy-mode and window-number-mode
  (company-global-modes '(not ivy-mode window-number-mode))
  :config
  (global-company-mode t)
  )

;; A company front-end with icons
(use-package company-box
  :ensure t
  :after company
  :delight
  :hook (company-mode . company-box-mode)
  )

(use-package magit
  :ensure t
  :bind (("C-x g s" . magit-status)
         ("C-x g m" . magit-branch-manager))
  :config
  (set-default 'magit-stage-all-confirm nil)
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)

  ;; full screen magit-status
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  )

(use-package lsp-mode
  :ensure t
  :hook ((c-mode c++-mode dart-mode java-mode json-mode python-mode typescript-mode xml-mode) . lsp)
  :custom
  (lsp-clients-typescript-server-args '("--stdio" "--tsserver-log-file" "/dev/stderr"))
  (lsp-enable-folding nil)
  (lsp-enable-links nil)
  (lsp-enable-snippet nil)
  (lsp-prefer-flymake nil)
  (lsp-session-file (expand-file-name (format "%s/emacs/lsp-session-v1" xdg-data)))
  (lsp-restart 'auto-restart)
  )

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  )

(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t)
  )

(use-package lsp-pyright
  :ensure t
  :if (executable-find "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))
  )

(use-package lsp-python-ms
  :ensure t
  :defer 0.3
  :custom (lsp-python-ms-auto-install-server t)
  )

(use-package python
  :delight "π "
  :bind (("M-[" . python-nav-backward-block)
         ("M-]" . python-nav-forward-block))
  :preface
  (defun python-remove-unused-imports()
    "Removes unused imports and unused variables with autoflake."
    (interactive)
    (if (executable-find "autoflake")
        (progn
          (shell-command (format "autoflake --remove-all-unused-imports -i %s"
                                 (shell-quote-argument (buffer-file-name))))
          (revert-buffer t t t))
      (warn "python-mode: Cannot find autoflake executable.")))
  )

(use-package pyenv-mode
  :ensure t
  :after python
  :hook ((python-mode . pyenv-mode)
         (projectile-switch-project . projectile-pyenv-mode-set))
  :custom (pyenv-mode-set "3.8.5")
  :preface
  (defun projectile-pyenv-mode-set ()
    "Set pyenv version matching project name."
    (let ((project (projectile-project-name)))
      (if (member project (pyenv-mode-versions))
          (pyenv-mode-set project)
        (pyenv-mode-unset))))
  )

(use-package pyvenv
  :ensure t
  :after python
  :hook ((python-mode . pyvenv-mode)
         (python-mode . (lambda ()
                          (if-let ((pyvenv-directory (find-pyvenv-directory (buffer-file-name))))
                              (pyvenv-activate pyvenv-directory))
                          (lsp))))
  :custom
  (pyvenv-default-virtual-env-name "env")
  (pyvenv-mode-line-indicator '(pyvenv-virtual-env-name ("[venv:"
                                                         pyvenv-virtual-env-name "]")))
  :preface
  (defun find-pyvenv-directory (path)
    "Checks if a pyvenv directory exists."
    (cond
     ((not path) nil)
     ((file-regular-p path) (find-pyvenv-directory (file-name-directory path)))
     ((file-directory-p path)
      (or
       (seq-find
        (lambda (path) (file-regular-p (expand-file-name "pyvenv.cfg" path)))
        (directory-files path t))
       (let ((parent (file-name-directory (directory-file-name path))))
         (unless (equal parent path) (find-pyvenv-directory parent)))))))
  )
