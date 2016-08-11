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
(blink-cursor-mode 0)			; turn off cursor blink
(scroll-bar-mode 0)			; turn off scroll bars
(tool-bar-mode 0)			; turn off tool bars
(menu-bar-mode 0)			; turn off menu bars
(setq visible-bell t)			; no beeping


;;; correct backspace on terminals
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-x h") 'help-command)

;;; make the mode line fancy
;;;;;(size-indication-mode)			; show how big this buffer is
(setq display-time-default-load-average nil) ; don't show the load average

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
(if (not (display-graphic-p))
    (add-to-list 'default-frame-alist '(background-color . "black")))
					; so that the color of leading asterisks is less prominent
(add-hook 'org-mode-hook 'flyspell-mode)

;;; LaTeX mode
(add-hook 'latex-mode-hook 'visual-line-mode) ; wrap long lines

;;; packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;;; themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)

;;; gtd.org
(defun reset-checklist ()
  "Resets the top checklist items in my gtd.org file."
  (interactive)
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (narrow-to-region
       (re-search-forward "^\* " nil t)	 ; start of checklist
       (re-search-forward "^\* " nil t)) ; first context after checklist
      (goto-char (point-min))
      (re-search-forward "^DONE" nil t)	; find the top-level "DONE" for the whole checklist
      (replace-match "TODO" nil nil)
      (while (re-search-forward "^\*\* DONE" nil t)
	(replace-match "** TODO" nil nil)))))

;;; Feel free to define these keys however you like--the keybinding conventions
;;; promise that you will not clobber anything:
;;;    C-c <upper-case-letter>
;;;    C-c <lower-case-letter>
;;;    <f5>
;;;    <f6>
;;;    <f7>
;;;    <f8>
;;;    <f9>
(global-set-key (kbd "<f9>") 'reset-checklist)


;;; EMMS -- media playback
(add-to-list 'load-path "~/.emacs.d/emms/lisp")
(require 'emms-setup)
(emms-all)
(emms-default-players)
(setq emms-source-file-default-directory "~/Music/")
(global-set-key (kbd "<XF86AudioStop>") 'emms-stop)
(global-set-key (kbd "<XF86AudioPlay>") 'emms-pause)
(global-set-key (kbd "<XF86AudioNext>") 'emms-next)
(global-set-key (kbd "<XF86AudioPrev>") 'emms-previous)




;;;-----------------------------------------------------------------------------



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("06b2849748590f7f991bf0aaaea96611bb3a6982cad8b1e3fc707055b96d64ca" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
