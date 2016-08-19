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

;;; battery
(display-battery-mode 1)
(setq battery-update-interval 10)


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
(add-hook 'org-mode-hook 'flyspell-mode)

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
      (narrow-to-region
       (re-search-forward "^\* " nil t)	 ; start of checklist
       (re-search-forward "^\* " nil t)) ; first context after checklist
      (goto-char (point-min))
      (re-search-forward "^DONE" nil t)	; find the top-level "DONE" for the whole checklist
      (replace-match "TODO" nil nil)
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


;;; Feel free to define these keys however you like--the keybinding conventions
;;; promise that you will not clobber anything:
;;;    C-c <upper-case-letter>
;;;    C-c <lower-case-letter>
;;;    <f5>
;;;    <f6>
;;;    <f7>
;;;    <f8>
;;;    <f9>
(global-set-key (kbd "<f8>") 'work)
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

;;; Evil
(require 'evil)
(evil-mode 1)

;;; Yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;;; Helm
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c h g") 'helm-google-suggest)
(global-set-key (kbd "C-c h M-:") 'helm-eval-expression-with-eldoc)


;;; server
(server-start)


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
