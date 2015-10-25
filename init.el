;;;
;;; Gnu Emacs Startup File
;;;

;;; Miscellaneous options
(setq require-final-newline t)	        ; assures the newline at eof
(setq make-backup-files nil)		; no backup copies of files
(setq colon-double-space t)		; two spaces after each colon
(setq inhibit-splash-screen t)          ; oh god, just cut it out
(setq initial-scratch-message ";; Customized!\n\n")	; my comment in the scratch buffer
(setq echo-keystrokes 0.1)		; see what you are typing as you type it
(setq scroll-conservatively 1)		; no jump-scrolling
(setq scroll-margin 2)			; cursor this many lines away from edges

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
(setq display-time-default-load-average nil) ; don't show the load average
(setq display-time-format		; use ISO format for date and time
      " %F  %R")
(display-time)				; put the time on the mode line

;;; a bigger window, sans toolbars.  height is the number of lines in the window
(setq default-frame-alist '((height . 31) (tool-bar-lines . 0) (menu-bar-lines . 1)))

;;; no menu bar in terminal windows
(if (not (display-graphic-p))
    (menu-bar-mode -1))

;;; toggle off scroll bars on all frames, both now and in the future
(scroll-bar-mode)

;;; font.  :height is the point size of the font times 10.
(if (not (eq system-type 'windows-nt))	; Inconsolata isn't installed at work
    (set-face-attribute 'default nil :font "Inconsolata" :height 140))

;;; tail
(defun tail ()
  "Prompts for a file name, then displays a tail of that file."
  (interactive)
  (find-file (read-file-name "Tail: "))
  (auto-revert-tail-mode)
  (end-of-buffer))

;;; Org mode
(add-hook 'org-mode-hook 'visual-line-mode) ; wrap long lines
(setq org-startup-indented t)		    ; hide leading asterisks

;;; LaTeX mode
(add-hook 'latex-mode-hook 'visual-line-mode) ; wrap long lines

;;; Marmalade
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

