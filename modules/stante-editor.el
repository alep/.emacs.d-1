;;; stante-editor.el --- Stante Pede Modules: Basic editing -*- lexical-binding: t; -*-
;;
;; Copyright (c) 2012, 2013 Sebastian Wiesner
;;
;; Author: Sebastian Wiesner <lunaryorn@gmail.com>
;; URL: https://gihub.com/lunaryorn/stante-pede.git
;; Keywords: abbrev convenience wp

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 3 of the License, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.

;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
;; USA.


;;; Commentary:

;; Configure general editing.

;; Indentation and tabs
;; --------------------
;;
;; Set the default `tab-width' is set to 8, but disable indentation with tabs.
;; Setup Return key to indent automatically.

;; Filling
;; -------
;;
;; Enable `auto-fill-mode' in all text modes and increase the default fill
;; column to 80 characters, which is the maximum recommended by most programming
;; style guides.
;;
;; Show a fill column indicator in programming and text modes.

;; Parenthesis, brackets, etc.
;; --------------------------
;;
;; Automatically insert matching parenthesis, and highlight matching
;; parenthesis.

;; Highlighting
;; ------------
;;
;; Highlight the current line (see `global-hl-line-mode') and the results of
;; some text operations like yanking, killing and deleting (see
;; `volatile-highlights-mode').
;;
;; Indicate empty lines at the end of the file.

;; Region
;; ------
;;
;; Expand the region by semantic units with `er/expand-region'.
;;
;; Wrap the region with Wrap Region Mode.

;; Multiple cursors
;; ----------------
;;
;; Edit text with multiple cursors.
;;
;; See https://github.com/magnars/multiple-cursors.el

;; Narrowing and widening
;; ----------------------
;;
;; Enable narrowing commands `narrow-to-region' (C-x n n), `narrow-to-page' (C-x
;; n p) and `narrow-to-defun' (C-x n d).  These commands reduce the visible text
;; to the current region (or page or defun, respectively).  Use `widen' (C-x n
;; w) to remove narrowing.

;; History
;; -------
;;
;; Save and restore minibuffer history, recent files and the location of point
;; in files.

;; Expansion
;; ---------
;;
;; Provide powerful word expansion with a reasonable `hippie-expand'
;; configuration.

;; Emacs server
;; ------------
;;
;; Start an Emacs server, if there is none running yet.
;;
;; This allows to edit files within the currently running Emacs session with
;; "emacsclient".

;; Keybindings
;; -----------
;;
;; Swap isearch and isearch-regexp keybindings.
;;
;; C-<backspace> kills a line backwards and re-indents.
;;
;; C-S-<backspace> kills a whole line and moves back to indentation.
;;
;; S-return or C-S-j insert a new empty line below the current one.
;;
;; C-c o shows matching lines in a new window via `occur'.
;;
;; M-/ dynamically expands the word under point with `hippie-expand'.
;;
;; M-Z zaps up to, but not including a specified character, similar to
;; `zap-to-char` (see `zap-up-to-char`).
;;
;; C-= expands the current region with the closest surrounding semantic unit
;; (see `er/expand-region').
;;
;; C-c SPC starts Ace Jump mode to quickly navigate in the buffer.  C-x SPC
;; jumps back.
;;
;; M-S-up and M-S-down move the current line or region up and down respectively.

;; Multiple cursor keybindings
;; +++++++++++++++++++++++++++
;;
;; The C-c m keymap provides commands to work with multiple cursors
;;
;; l edits the selected lines with multiple cursors.
;;
;; C-a and C-e add a cursor to the beginning and end of all selected lines
;; respectively.
;;
;; C-s prompts for a text to edit with multiple cursors.
;;
;; > and < add a cursor to the next and previous matching thing.
;;
;; e lets you selectively add cursors to the next or previous matching thing.
;;
;; h adds a cursor to all matching things, in a do-what-I-mean kind of way.
;; Repeat to add cursors to more things.

;; File keybindings
;; ++++++++++++++++
;;
;; The C-c f keymap provides commands to work with files:
;;
;; o opens the currently visited file externally.
;;
;; r finds a recently used file with IDO.
;;
;; R renames the current file and buffer.
;;
;; D deletes the current file and buffer.
;;
;; w copies the name of currently visited file into the kill ring.

;;; Code:

(eval-when-compile
  (require 'drag-stuff)
  (require 'whitespace)
  (require 'multiple-cursors)
  (require 'paren)
  (require 'electric)
  (require 'savehist)
  (require 'recentf)
  (require 'saveplace)
  (require 'bookmark))
(require 'dash)

;; Move backup and autosave files to var directory.
(setq backup-directory-alist
      `((".*" . ,(expand-file-name "backup" stante-var-dir)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save" stante-var-dir) t)))

;; Sane coding system choice
(prefer-coding-system 'utf-8)

;; Automatically revert buffers from changed files
(global-auto-revert-mode 1)

;; Delete selection when entering new text
(delete-selection-mode)

;; View readonly files
(setq view-read-only t)

;; Preserve clipboard text before killing
;; This would be a really nice addition, but Emacs has the stupid habit
;; of constantly signalling errors if the paste content is not supported or
;; empty. Obviously this breaks killing completely.  Really great thanks to you,
;; whoever crazy mind got that silly idea…
;; (setq save-interprogram-paste-before-kill t)

;; No tabs for indentation
(setq-default indent-tabs-mode nil
              tab-width 8)

;; Multiple cursors
(after 'multiple-cursors-core
  (setq mc/list-file (expand-file-name "mc-lists.el" stante-var-dir)))

;; Drag stuff around
(drag-stuff-global-mode)
(after 'drag-stuff
  (setq drag-stuff-modifier '(meta shift))
  (diminish 'drag-stuff-mode))

;; Configure filling
(setq-default fill-column 80)
(after 'whitespace
  (setq whitespace-line-column nil))
(--each '(prog-mode-hook text-mode-hook)
  (add-hook it 'fci-mode))

;; Configure wrapping
(add-hook 'text-mode-hook 'adaptive-wrap-prefix-mode)

;; Power up parenthesis
(smartparens-global-mode)
(show-smartparens-global-mode)
(after 'smartparens
  (require 'smartparens-config)

  ;; Use Paredit-like keybindings.  The Smartparens bindings are too obtrusive,
  ;; shadow otherwise useful bindings (e.g. M-<backspace>), and use the arrow
  ;; keys too much
  (sp-use-paredit-bindings)

  (diminish 'smartparens-mode))

;; Highlights
(global-hl-line-mode 1)
(require 'volatile-highlights)          ; Volatile Highlights doesn't autoload
(volatile-highlights-mode t)
(after 'volatile-highlights (diminish 'volatile-highlights-mode))

(after 'whitespace
  (setq whitespace-style '(face tabs empty trailing lines-tail))
  (diminish 'whitespace-mode))

(setq indicate-empty-lines t)

;; Cleanup stale buffers
(require 'midnight)

;; Narrowing
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; Remember minibuffer history
(after 'savehist
  (setq savehist-save-minibuffer-history t
        ;; Save every three minutes (the default five minutes is a bit long)
        savehist-autosave-interval 180
        ;; Move save file into proper directory
        savehist-file (expand-file-name "savehist" stante-var-dir)))
(savehist-mode t)

;; Recent files
(after 'recentf
  (setq recentf-max-saved-items 200
        recentf-max-menu-items 15
        ;; Move to property directory
        recentf-save-file (expand-file-name "recentf" stante-var-dir)))
(recentf-mode t)

;; Remember locations in files
(after 'saveplace
  (setq save-place-file (expand-file-name "saveplace" stante-var-dir))
  (setq-default save-place t))
(require 'saveplace)

;; Configure bookmarks
(after 'bookmark
  (setq bookmark-default-file (expand-file-name "bookmarks" stante-var-dir)
        ;; Save on every modification
        bookmark-save-flag 1))

;; Completion
(setq completion-cycle-threshold 5)     ; Cycle with less than 5 candidates

;; Expansion functions
(after 'hippie-exp
  (setq hippie-expand-try-functions-list
        '(try-expand-dabbrev
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill
          try-complete-file-name-partially
          try-complete-file-name
          try-expand-all-abbrevs
          try-expand-list
          try-expand-line
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol)))

;; Bring up Emacs server
(require 'server)
(unless (server-running-p) (server-start))

;; Flymake reloaded :)
(global-flycheck-mode)

;; Update copyright lines automatically
(add-hook 'find-file-hook 'copyright-update)

;; Some missing autoloads
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.")

;; Keybindings
(defvar stante-multiple-cursors-map
  (let ((map (make-sparse-keymap)))
    (define-key map "l" #'mc/edit-lines)
    (define-key map (kbd "C-a") #'mc/edit-beginnings-of-lines)
    (define-key map (kbd "C-e") #'mc/edit-ends-of-lines)
    (define-key map (kbd "C-s") #'mc/mark-all-in-region)
    (define-key map ">" #'mc/mark-next-like-this)
    (define-key map "<" #'mc/mark-previous-like-this)
    (define-key map "e" #'mc/mark-more-like-this-extended)
    (define-key map "h" #'mc/mark-all-like-this-dwim)
    map)
  "Key map for multiple cursors.")

(defvar stante-file-commands-map
  (let ((map (make-sparse-keymap)))
    (define-key map "r" #'stante-ido-find-recentf)
    (define-key map "o" #'stante-open-with)
    (define-key map "R" #'stante-rename-file-and-buffer)
    (define-key map "D" #'stante-delete-file-and-buffer)
    (define-key map "w" #'stante-copy-filename-as-kill)
    map)
  "Key map for file functions.")

;; Swap isearch and isearch-regexp
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "C-<backspace>") 'stante-smart-backward-kill-line)
(global-set-key [remap kill-whole-line] 'stante-smart-kill-whole-line)
(global-set-key (kbd "C-S-j") 'stante-smart-open-line)
(global-set-key [(shift return)] 'stante-smart-open-line)
(global-set-key (kbd "C-c o") 'occur)
(global-set-key (kbd "M-Z") 'zap-up-to-char)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-=") 'er/expand-region) ; As suggested by documentation
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)
(global-set-key (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; Some standard user maps
(global-set-key (kbd "C-c f") stante-file-commands-map)
(global-set-key (kbd "C-c m") stante-multiple-cursors-map)

(provide 'stante-editor)

;; Local Variables:
;; coding: utf-8
;; End:

;;; stante-editor.el ends here
