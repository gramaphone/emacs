;;;
;;; Emacs Startup File
;;;

;;; Miscellaneous options
(setq require-final-newline t)	        ; assures the newline at eof
(setq make-backup-files nil)		; no backup copies of files
(setq colon-double-space t)		; two spaces after each colon
(setq inhibit-splash-screen t)          ; oh god, just cut it out
(setq initial-scratch-message ";; Customized!\n\n")	; my comment in the scratch buffer
(menu-bar-mode 0)			; turn off menu bars
(setq visible-bell t)			; no beeping
(setq view-read-only t)			; read-only files should use view-mode by default
(setq echo-keystrokes 0.1)              ; see what you are typing as you type it

(if (display-graphic-p)
    (progn
      (blink-cursor-mode 0)		; turn off cursor blink
      (scroll-bar-mode 0)		; turn off scroll bars
      (tool-bar-mode 0)			; turn off tool bars
      ))

;;; get the files that I always like to have loaded
;;; note that the last file in this list is the buffer I see on startup
(mapc 'find-file
      '("~/projects/current/"
	"~/Documents/"
	"~/.emacs.d/init.el"
	"~/Documents/gtd.org"))      

;;; battery
(display-battery-mode 1)
(setq battery-update-interval 10)

;;; make the mode line fancy
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
(if (display-graphic-p)
    (setq org-startup-indented t))	; hide leading asterisks
(setq org-use-speed-commands t)	        ; single-letter commands at beginning of a headline
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

;;; packages
(require 'package)
(add-to-list 'package-archives
;;;;; '("melpa-archive" . "https://elpa.zilongshanren.com/melpa/"))
	     '("melpa" . "http://melpa.org/packages/"))
;;;;;	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;; themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(if (display-graphic-p)
    (load-theme 'zenburn t))

;;; gtd.org
(defun reset-checklist ()
  "Resets the top checklist items in my gtd.org file."
  (interactive)
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (org-narrow-to-subtree)
      (if (re-search-forward "^\* DONE" nil t)	; find the top-level "DONE" for the whole checklist
	  (replace-match "* TODO" nil nil))
      (goto-char (point-min))
      (while (re-search-forward "^\*\* DONE" nil t)
	(replace-match "** TODO" nil nil)))))

(defun show-context (context)
  "Shows the subtree for a particular context in my gtd.org file."
  (save-excursion
    (goto-char (point-min))
    (re-search-forward (concat "^\* " context) nil t)
    (show-subtree)))

(defun hide-all-contexts ()
  "Hides all the contexts in my gtd.org file."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^\* " nil t)
      (hide-subtree))))

(defun show-these-contexts (&rest contexts)
  "Shows just these contexts in my gtd.org file."
  (hide-all-contexts)
  (mapc 'show-context contexts))

(defun work ()
  "Opens just the contexts I need when I'm at work."
  (interactive)
  (show-these-contexts
   "Daily checklist"
   "Anywhere"
   "Computer"
   "Computer - Internet - Work"
   "Work"
   "Waiting for"
   "Projects - Work"))


;;; MH-E -- mail
(setq mh-inc-prog "/home/dan/bin/finc")


;;; EMMS -- media playback
(add-to-list 'load-path "~/.emacs.d/emms/lisp")
(require 'emms-setup)
(emms-all)
(emms-default-players)
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
(global-set-key (kbd "<f5>") 'load-music)
(global-set-key (kbd "<f6>") 'mh-rmail)
(global-set-key (kbd "<f8>") 'work)
(global-set-key (kbd "<f9>") 'reset-checklist)



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
