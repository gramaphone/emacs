
;;;
;;; Gnu Emacs Startup File
;;;
;;; re-created 2013-10-10
;;;
;;; -dp
;;;

;;; Miscellaneous options
(setq require-final-newline t)	        ; assures the newline at eof
(setq make-backup-files nil)		; no backup copies of files
(setq colon-double-space t)		; two spaces after each colon
(setq inhibit-splash-screen t)          ; oh god, just cut it out
(setq initial-scratch-message ";; Customized!\n\n")	; no comment in the scratch buffer
(setq echo-keystrokes 0.1)		; see what you are typing as you type it
(setq scroll-conservatively 1)		; no jump-scrolling
(setq scroll-margin 2)			; cursor this many lines away from edges
;(setq-default indent-tabs-mode nil)    ; no tabs, please
(blink-cursor-mode 0)			; cursor blinkage

;;; correct backspace on terminals
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-x h") 'help-command)

;;; alt is alt, cmd is meta
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;;; make the mode line fancy
(size-indication-mode)			; show how big this buffer is
(setq display-time-format		; use ISO format for date and time
      " %Y-%m-%d  %H:%M ")
(display-time)				; put the time on the mode line

;;; a bigger window, sans toolbars.  height is the number of lines in the window
(setq default-frame-alist '((height . 31) (tool-bar-lines . 0) (menu-bar-lines . 1)))

;;; no menu bar in terminal windows
(if (not (display-graphic-p))
    (menu-bar-mode -1))

;;; a bigger font.  :height is the point size of the font times 10.
(set-face-attribute 'default nil :height 130)

;;; tail
(defun tail ()
  "Prompts for a file name, then displays a tail of that file."
  (interactive)
  (find-file (read-file-name "Tail: "))
  (auto-revert-tail-mode)
  (end-of-buffer))

;;; Common Lisp support
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(add-to-list 'load-path "~/Applications/slime-2010-08-03")
(require 'slime)
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

;;; Org mode
(add-hook 'org-mode-hook 'visual-line-mode) ; wrap long lines
(setq org-startup-indented t)		    ; hide leading asterisks

;;; Viper mode
;(setq viper-mode t)
;(require 'viper)

;;; LaTeX mode
(add-hook 'latex-mode-hook 'visual-line-mode) ; wrap long lines

;;; Marmalade
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
; '(org-hide ((t (:foreground "black"))))
)

