;; Make startup faster by reducing the frequency of garbage
;; collection. Freq is disproportional to size of gc.

(defconst emacs-start-time (current-time))

(setq gc-cons-threshold (* 100 1000 1000))
(setq byte-compile-warnings '(cl-functions))

(if (file-exists-p (expand-file-name "settings.el" user-emacs-directory))
    (load-file (expand-file-name "settings.el" user-emacs-directory))
  (org-babel-load-file (expand-file-name "settings.org" user-emacs-directory))
  )

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 10 1000 1000))

(defun uptime()
  (float-time
   (time-subtract (current-time) emacs-start-time))
  )
(message "Emacs started in %.3fs" (uptime))
