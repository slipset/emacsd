;; 
(setq gc-cons-threshold (* 1024 1024 100))

;; Keep emacs Custom-settings in separate file, not appended to init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Color all language features
(setq font-lock-maximum-decoration t)

;; Include entire file path in title
(setq frame-title-format '(buffer-file-name "%f" ("%b")))

;; Be less obnoxious
(blink-cursor-mode -1)
(tooltip-mode -1)
(setq-default cursor-type 'bar)
(setq display-time-24hr-format t)
(global-display-line-numbers-mode 1)
(setq split-height-threshold nil)
(setq-default fringes-outside-margins t)
(setq default-directory "~/")
(global-auto-revert-mode 1)
(setq indicate-empty-lines t)
(defalias 'yes-or-no-p 'y-or-n-p)

(set-face-attribute 'default nil :font "-*-Monoid-light-normal-semicondensed-*-*-*-*-*-m-0-iso10646-1")
;; Don't beep. Just blink the modeline on errors.
(setq ring-bell-function (lambda ()
                           (invert-face 'mode-line)
                           (run-with-timer 0.05 nil 'invert-face 'mode-line)))

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(add-to-list 'load-path (expand-file-name "packages" user-emacs-directory))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures
   'prog-mode
   '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
     ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
     "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
     "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
     "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
     "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
     "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
     "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
     ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
     "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
     "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
     "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
     "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

(use-package atom-dark-theme)
(load-theme 'atom-dark)

(setq default-input-method "MacOSX")
(setq mac-option-modifier 'none)
(setq mac-command-modifier 'meta)

(use-package magit)
(use-package forge
  :after magit)
(use-package editorconfig)
(use-package diminish)
(use-package window-purpose)
(use-package ag)
(use-package paredit)
(use-package paredit-menu)
(use-package counsel)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(use-package forge
  :after magit)


(setq magit-refresh-status-buffer nil) ;; Disable auto-refresh on save (manual 'g' instead)

;; Remove the slowest "header" and "extra" sections
(remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
(remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
(remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
(remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
(remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
(remove-hook 'magit-status-sections-hook 'forge-insert-merged-pullreqs)

(defun my/magit-insert-branch-header-simple ()
  "Insert a header with only the current branch name, no upstream tracking."
  (let ((branch (magit-get-current-branch)))
    (when branch
      (insert (propertize "Head:  " 'face 'magit-header-line))
      (insert (propertize branch 'face 'magit-branch-local))
      (insert "\n"))))

;; Update your headers hook
(setq magit-status-headers-hook
      '(my/magit-insert-branch-header-simple
        magit-insert-diff-filter-header))

(use-package projectile
  :init
  (setq projectile-mode-line '(:eval (format " [%s]" (projectile-project-name))))
  (setq projectile-globally-ignored-file-suffixes '("#~"))

  (setq projectile-keymap-prefix (kbd "C-c p"))
  :config
  (projectile-mode))

(use-package fill-column-indicator
  :init
  (setq fci-rule-color "grey30")
  (setq fci-rule-column 80)
  (setq fci-handle-truncate-lines nil)
  :config
  (define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
  (global-fci-mode 1))

;;; programming stuff
(use-package paredit)
(use-package company)
(use-package company-box
  :hook (company-mode . company-box-mode))



(use-package typescript-ts-mode
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)))

(use-package prettier-js)
(add-hook 'typescript-ts-mode-hook 'prettier-js-mode)
(add-hook 'tsx-ts-mode-hook 'prettier-js-mode)
(add-hook 'typescript-ts-mode-hook
          (lambda ()
            (setq-local lsp-enable-on-type-formatting nil)))

(use-package jest
  :ensure t
  :hook (typescript-ts-mode . jest-minor-mode)
  :bind (:map jest-minor-mode-map
         ("C-c C-t t" . jest-function)
         ("C-c C-t b" . jest-file)
         ("C-c C-t a" . jest-project)))

(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

(use-package cider)
(use-package clj-refactor)
(use-package flycheck-clojure)

(eval-after-load 'flycheck '(flycheck-clojure-setup))
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq cider-lein-command "lein")
(setq cider-repl-result-prefix ";; => ")
(setq cider-repl-use-clojure-font-lock t)
(setq nrepl-hide-special-buffers nil)
(setq cider-show-error-buffer nil)
(setq cider-auto-select-error-buffer nil)
(setq cider-repl-use-pretty-printing t)
(setq cider-repl-use-clojure-font-lock t)
(setq cljr-warn-on-eval nil)
(add-hook 'cider-repl-mode-hook 'company-mode)
(add-hook 'cider-mode-hook 'company-mode)
(add-hook 'cider-mode-hook 'eldoc-mode)

(add-hook 'cider-mode-hook 'enable-paredit-mode)

(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook 'clj-refactor-mode)
(add-hook 'clojure-mode-hook 'copilot-mode)

(defun setup-cljr ()
  (cljr-add-keybindings-with-prefix "C-c C-m"))

(add-hook 'clojure-mode-hook #'setup-cljr)

(setq-default flycheck-disabled-checkers '(clojure-cider-typed))

(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :config
  (setq copilot-indent-offset-warning-disable t))

(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)

(use-package lsp-mode
  :bind ((:map lsp-mode-map
	       ("M-<return>" . lsp-execute-code-action))
	 (:map lsp-mode-map
	       ("C-c C-r" . lsp-find-references)))
  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp)
	 (typescript-ts-mode . lsp-deferred)
	 (tsx-ts-mode . lsp-deferred))
  :init (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  :config
  (setq lsp-lens-place-position 'above-line)
  (setq lsp-lens-enable t)

  ;; add paths to your local installation of project mgmt tools, like lein
  (setenv "PATH" (concat
                  "/opt/homebrew/bin" path-separator
                  "/usr/local/bin" path-separator
                  (getenv "PATH")))
  (setq exec-path (append '("/opt/homebrew/bin" "/usr/local/bin") exec-path))
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode))
     (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))
  (add-to-list 'lsp-language-id-configuration '(typescript-ts-mode . "typescript"))
  (add-to-list 'lsp-language-id-configuration '(tsx-ts-mode . "typescriptreact")))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-disabled-clients 'ts-ls)

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("vtsls" "--stdio"))
    :activation-fn (lsp-activate-on "typescript" "typescriptreact")
    :priority 1
    :server-id 'vtsls
    :initialization-options (lambda ()
                              (ht ("typescript" (ht ("referencesCodeLens" (ht ("enabled" t) ("showOnAllFunctions" t)))
                                                    ("implementationsCodeLens" (ht ("enabled" t)))))
                                  ("javascript" (ht ("referencesCodeLens" (ht ("enabled" t) ("showOnAllFunctions" t)))))))
    :initialized-fn (lambda (workspace)
                      (with-lsp-workspace workspace
                        (lsp--set-configuration
                         (ht ("typescript" (ht ("referencesCodeLens" (ht ("enabled" t) ("showOnAllFunctions" t)))
                                               ("implementationsCodeLens" (ht ("enabled" t)))))
                             ("javascript" (ht ("referencesCodeLens" (ht ("enabled" t) ("showOnAllFunctions" t))))))))))))
(use-package lsp-ui
  :after lsp-mode
  :custom (lsp-ui-peek-enable nil)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-delay 1)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-show-diagnostics nil)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-update-mode 'point)
  (lsp-ui-sideline-delay 1))

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config (setq git-gutter:update-inverval 0.02))

(use-package smartparens
  :hook ((typescript-ts-mode . smartparens-mode)
         (tsx-ts-mode . smartparens-mode))
  :config
  (require 'smartparens-config)
  (define-key smartparens-mode-map (kbd "C-)") 'sp-forward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-(") 'sp-backward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-}") 'sp-forward-barf-sexp)
  (define-key smartparens-mode-map (kbd "C-{") 'sp-backward-barf-sexp)
  (define-key smartparens-mode-map (kbd "C-M-k") 'sp-kill-sexp)
  (define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)
  (define-key smartparens-mode-map (kbd "M-R") 'sp-raise-sexp)
  (define-key smartparens-mode-map (kbd "M-s") 'sp-splice-sexp))

(use-package beacon
  :defer t
  :init  (beacon-mode 1)
  :config
  (setq beacon-blink-when-window-scrolls nil))

(global-git-gutter-mode +1)
(add-hook 'git-gutter:update-hooks 'magit-revert-buffer-hook)
(setq git-gutter-fr:side 'right-fringe)

(global-set-key (kbd "C-x C-g") 'magit-status)
(define-key global-map (kbd "RET") 'newline-and-indent)
