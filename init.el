;; bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; setup straight use-package
(straight-use-package 'use-package)

(use-package exec-path-from-shell
  :straight t
  :if (memq window-system '(mac))
  :config
  (exec-path-from-shell-initialize))

(use-package catppuccin-theme
  :straight t
  :config
  (load-theme 'catppuccin :no-confirm))

(use-package emacs
  :custom
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p)
  :hook
  (prog-mode . (lambda ()
                 (setq display-line-numbers 'relative)))
  :init
  (set-face-attribute 'default nil :font "Monaspace Argon" :height 160))

(setq me/config-org-file (expand-file-name (file-name-concat user-emacs-directory "init.org")))
(setq me/config-file (expand-file-name (file-name-concat user-emacs-directory "init.el")))

(defun me/edit-config ()
  "Open the literate config file for editing"
  (interactive)
  (find-file me/config-org-file))

(defun me/reload-config ()
  "Reload the config file to reflect changes (mostly)"
  (interactive)
  (load-file me/config-file))

(defun me/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      me/config-org-file)
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'me/org-babel-tangle-config)))

;; dirty vim user
(use-package evil
  :straight t
  :custom
  (evil-undo-system 'undo-redo)
  (evil-want-C-u-delete t)
  (evil-want-C-u-scroll t)
  (evil-want-Y-yank-to-eol t)
  (evil-respect-visual-line-mode t)
  :config
  (evil-mode t))

(use-package parinfer-rust-mode
  :straight t
  :custom
  (parinfer-rust-disable-troublesome-modes t)
  :hook (emacs-lisp-mode lisp-mode))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package vertico
  :straight t
  :config
  (vertico-mode))

(use-package marginalia
  :straight t
  :init
  (marginalia-mode))

(use-package corfu
  :straight t
  :init
  (global-corfu-mode))

(use-package corfu-terminal
  :straight t
  :after corfu
  :if (not (display-graphic-p))
  :init (corfu-terminal-mode t))
