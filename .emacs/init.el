;; to bring emacs to the front
;;(x-focus-frame nil)
;; keys remap
(setq ns-command-modifier 'meta)
(setq ns-function-modifier 'control)
;; ----------------------------------------------------
;; duplicate line in emacs with a single key:   C-c d
;; ----------------------------------------------------
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))
(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)
;; Prevent the cursor from blinking
(blink-cursor-mode 0)
;; linum mode by default
(global-linum-mode 1)
;; max screen according to resolution by default
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; auto complete mode always on
;(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20150618.1949")
;(add-to-list 'load-path "~/.emacs.d/elpa/popup-20150626.711")
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories (expand-file-name "~/.emacs.d/elpa/auto-complete-20150618.1949/dict"))
;(ac-config-default)

;(ac-set-trigger-key "TAB")
;(setq ac-quick-help-delay 0.5)
;(setq ac-auto-start t)
(setq default-tab-width 2)
;; display of column for a line.
(setq column-number-mode t)
;; Don't use messages that you don't read
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
;; Don't let Emacs hurt your ears
(setq visible-bell t)
;; You need to set `inhibit-startup-echo-area-message' from the
;; customization interface:
;;M-x customize-variable RET inhibit-startup-echo-area-message RET
;; then enter your username
(setq inhibit-startup-echo-area-message "Jayanth's Emacs")
;; This is bound to f11 in Emacs
;;(toggle-frame-fullscreen) 
;; Who use the bar to scroll?
(scroll-bar-mode 0)
;; for complete naked-emacs
(tool-bar-mode 0)
(menu-bar-mode 0)
;; ==========================================================
;; commmand remappings
;; ==========================================================
;; spli-windows -> not very convinient on mac
;;(global-set-key [f1] 'split-window-vertically) 
;;(global-set-key [f2] 'other-window) 
;;(global-set-key [f3] 'delete-window) 
(global-set-key "\C-l" 'goto-line)
(global-set-key "\C-R" 'query-replace)
(display-time)
;; Set the color of the fringe/left-right-boundary
(custom-set-faces
 '(fringe ((t (:background "white")))))
;; appearance/colors
;; replace the below two 'white' with gray20 to revert back
(custom-set-faces
  '(default ((t (:background "gray20" :foreground "PaleGoldenrod"))))
  '(fringe ((t (:background "gray20")))))
;; to highlight certain words that are not language keywords
(add-hook 'c-mode-common-hook
               (lambda ()
                (font-lock-add-keywords nil
                 '(("\\<\\(FIXME\\|EDGE_CASE\\|TODO\\|NOTE\\|BUG\\):" 1 font-lock-warning-face t)))))
;; ----------------------------------------------------
;; rename the open file
;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
;; ----------------------------------------------------
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))
;; ----------------------------------------------------
;; include melpa package
;; ----------------------------------------------------
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))
;; ----------------------------------------------------
;; golang mode
;; ----------------------------------------------------
(setq load-path (cons "/usr/local/go/misc/emacs" load-path))                                         
(require 'go-mode-load)

;; DOCKERFILE mode
;;(add-to-list 'load-path "/Users/jmettu/.emacs.d/dockerfile-mode.el")
;;(require 'dockerfile-mode)
;;(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
