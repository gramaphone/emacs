;;;
;;; Emacs Startup File
;;;

;;; Miscellaneous options
(setq require-final-newline t)	        ; assures the newline at eof
(setq make-backup-files nil)		; no backup copies of files
(setq colon-double-space t)		; two spaces after each colon
(setq inhibit-splash-screen t)          ; oh god, just cut it out
(setq initial-scratch-message nil)	; no comment in the scratch buffer
(menu-bar-mode 0)			; turn off menu bars
(setq visible-bell t)			; no beeping
(setq view-read-only t)			; read-only files should use view-mode by default
(setq echo-keystrokes 0.1)              ; see what you are typing as you type it
(electric-pair-mode)			; keep your parentheses balanced

(if (display-graphic-p)
    (progn
      (blink-cursor-mode 0)		; turn off cursor blink
      (scroll-bar-mode 0)		; turn off scroll bars
      (tool-bar-mode 0)			; turn off tool bars
      ))


;;; need this to make /usr/bin/emacsclient work
(server-start)


;;; battery
(display-battery-mode 1)
(setq battery-update-interval 10)


;;; TidalCycles
(add-to-list 'load-path "~/.emacs.d/tidal")
(require 'haskell-mode)
(require 'tidal)


;;; Org mode
(add-hook 'org-mode-hook 'visual-line-mode) ; wrap long lines
(setq org-startup-indented t)		    ; get the spacing correct
(setq org-hide-leading-stars t)		    ; hide leading asterisks
(setq org-use-speed-commands t)	            ; single-letter commands at beginning of a headline
(add-hook 'org-mode-hook 'flyspell-mode)
(setq org-publish-project-alist
      '(("danpuckett.org"
	 :base-directory "~/Documents/website/org/"
	 :publishing-directory  "~/Documents/website/public_html/"
	 :publishing-function org-html-publish-to-html
	 :section-numbers nil
	 :with-toc nil)))
(setq org-html-preamble nil)
(setq org-html-postamble nil)
(setq org-html-head-include-default-style nil)
(setq org-html-head-include-scripts nil)

;;; LaTeX mode
(add-hook 'latex-mode-hook 'visual-line-mode) ; wrap long lines


;;; SLIME
(setq inferior-lisp-program "/usr/bin/sbcl"
      slime-contribs '(slime-fancy)
      common-lisp-hyperspec-root "/usr/share/doc/hyperspec/") ; "C-c C-d h" to look things up


;;; packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

;;; set up colors
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;;
;;; This is messed up, but here's the deal.  The ONLY reasonable way to get the nice
;;; high-contrast inverse-video mode that really works correctly with Org mode, etc., is
;;; by setting the following resource in .Xresources:
;;;
;;;     emacs.reverseVideo:	true
;;;
;;; I can't configure this within my init.el?  Nope.  Holy pants.
;;;

;;; And here's zenburn, in case you want low-contrast for some reason:
;;;(if (display-graphic-p)
;;;    (load-theme 'zenburn t))



;;; avy - a nicer "ace-jump-mode"
(avy-setup-default)
(global-set-key (kbd "C-:") 'avy-goto-char-timer)

;;; gtd.org
(defun reset-checklist ()
  "Resets the top checklist items in my gtd.org file."
  (interactive)
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (org-narrow-to-subtree)
      (if (re-search-forward "^\\* DONE" nil t)	; find the top-level "DONE" for the whole checklist
	  (replace-match "* TODO" nil nil))
      (goto-char (point-min))
      (while (re-search-forward "^\\*\\* DONE" nil t)
	(replace-match "** TODO" nil nil)))))

(defun show-context (context)
  "Shows the subtree for a particular context in my gtd.org file."
  (save-excursion
    (goto-char (point-min))
    (if (not (re-search-forward (concat "^\\* \\(TODO \\|DONE \\)?" context) nil t))
	(error "Can't find context '%s'.  Update init.el or gtd.org to reconcile them." context))
    (if (equal context "Daily checklist")
	(org-cycle)
      (show-subtree))))

(defun hide-all-contexts ()
  "Hides all the contexts in my gtd.org file."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^\\* " nil t)
      (hide-subtree))))

(defun show-these-contexts (contexts)
  "Shows just these contexts in my gtd.org file."
  (hide-all-contexts)
  (mapc 'show-context contexts))

(defun what-work-contexts-to-see ()
  "Returns a list of contexts that I want to view at work."
  (let ((contexts '("Next actions"
		    "Waiting for"
		    "Projects - Work")))
    (save-excursion
      (goto-char (point-min))
      (if (re-search-forward "^\\* DONE Daily checklist" nil t)
	  contexts
	(cons "Daily checklist" contexts)))))
  
(defun work ()
  "Opens just the contexts I need when I'm at work."
  (interactive)
  (show-these-contexts (what-work-contexts-to-see)))


;;; Navigate my GTD file
(defun move-to-top-daily-todo ()
  "Moves the cursor to the first item flagged as 'TODO' in the daily checklist."
  (interactive)
  (goto-char (point-min))
  (org-narrow-to-subtree)
  (re-search-forward "^\\*\\* TODO" nil t)
  (move-beginning-of-line nil)
  (widen))


;;; Move a line to the "Waiting for" context
(defun move-to-waiting-for ()
  "Moves the current line to the 'Waiting for' context and adds today's date."
  (interactive)
  (remove-todo)
  (move-beginning-of-line nil)
  (kill-line 1)
  (goto-end-of "Waiting for")
  (yank)
  (previous-line)
  (move-beginning-of-line nil)
  (re-search-forward "^\\*\\* " nil nil)
  (insert (format-time-string "%-m/%-d - "))
  (left-char 3))



(defun goto-end-of (context)
  "Moves cursor to the start of the context that comes after 'context'"
  (goto-char (point-min))
  (re-search-forward (concat "^\\* " context))
  (outline-forward-same-level 1))


;;; Adds a new item to the "Next actions" context
(defun add-new-item ()
  "Adds a new item to the 'Next actions' context, pushing a mark first so you can navigate back where you were before."
  (interactive)
  (work)
  (push-mark)
  (goto-end-of "Next actions")
  (previous-line)
  (org-end-of-line)
  (org-meta-return))


(defun remove-todo ()
  "Remove TODO from current item"
  (interactive)
  (move-beginning-of-line nil)
  (org-narrow-to-subtree)
  (if (re-search-forward "^\\*\\* TODO" nil t)
      (replace-match "**" nil nil))
  (widen))



(defun done-for-now ()
  "Remove TODO, move item to the bottom of the context, and leaves point on the next line below where it started."
  (interactive)
  (remove-todo)
  (move-beginning-of-line nil)
  (let ((a (point)))
    (outline-forward-same-level 1)
    (kill-region a (point)))
  (push-mark)
  (goto-end-of "Next actions")
  (yank)
  (pop-global-mark))


;;; Convert ORG files to a prettier format, so I can send them by e-mail
(defun prettify-org-file ()
  (interactive)
  (message "Hello, world."))


;;; Suppress prompts
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-nonexistent-file-or-buffer nil)
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
	    kill-buffer-query-functions))


;;; MH-E -- mail
(setq mh-inc-prog "/home/dan/bin/finc")
(setq mh-do-not-confirm-flag t)


;;; EMMS -- media playback
(add-to-list 'load-path "~/.emacs.d/emms/lisp")
(require 'emms-setup)
(emms-all)
(setq emms-player-list '(emms-player-vlc emms-player-vlc-playlist))
(setq emms-source-file-default-directory "~/Music/")
(setq emms-playlist-buffer-name "*Music*")
(global-set-key (kbd "<XF86AudioStop>") 'emms-stop)
(global-set-key (kbd "<XF86AudioPlay>") 'emms-pause)
(global-set-key (kbd "<XF86AudioNext>") 'emms-next)
(global-set-key (kbd "<XF86AudioPrev>") 'emms-previous)

(defun load-music ()
  "Load up my playlist (if necessary) and switch to the playlist buffer."
  (interactive)
  (if (not (get-buffer emms-playlist-buffer-name))
      (emms-add-directory-tree emms-source-file-default-directory))
  (emms-playlist-mode-go))


;;; Feel free to define these keys however you like--the keybinding conventions
;;; promise that you will not clobber anything:
;;;    C-c <upper-case-letter>
;;;    C-c <lower-case-letter>
;;;    <f5>
;;;    <f6>
;;;    <f7>
;;;    <f8>
;;;    <f9>
(global-set-key (kbd "<f5>")  'load-music)
(global-set-key (kbd "<f8>")  'work)
(global-set-key (kbd "<f9>")  'reset-checklist)
(global-set-key (kbd "C-c d") 'done-for-now)
(global-set-key (kbd "C-c n") 'add-new-item)
(global-set-key (kbd "C-c t") 'move-to-top-daily-todo)
(global-set-key (kbd "C-c w") 'move-to-waiting-for)



;;; C-z calls suspend-frame, which I never, ever want to do.
;;; I'm tired of pressing this key by accident.
(global-unset-key (kbd "C-z"))


;;; Magit!  Show thyself!
(global-set-key (kbd "C-x g") 'magit-status)


;;; This section must come before the find-file commands I
;;; run below, otherwise the files will already have their
;;; formatting set in place before I can configure the hidden
;;; stars to be black.
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-hide ((t (:foreground "black")))))



;;; load the files and directories that I always like to have loaded
;;; and set up the windows in the configuration I like to see
;;;
;;; last buffer in this list is the one shown on startup
(mapc 'find-file
      '(
	"~/projects/current/"
	"~/Documents/"
	"~/.emacs.d/init.el"
	"~/Documents/gtd.org"
	))
(work)



;;;-----------------------------------------------------------------------------



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("06b2849748590f7f991bf0aaaea96611bb3a6982cad8b1e3fc707055b96d64ca" default)))
 '(newsticker-url-list nil))
