(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
            (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
    'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                        ("melpa" . "https://melpa.org/packages/")
                        ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
        :ensure t
        :init
        (leaf hydra :ensure t)
        (leaf blackout :ensure t)

        :config
        (leaf-keywords-init)))

  (leaf leaf
        :config
        (leaf leaf-convert :ensure t)
        (leaf leaf-tree
              :ensure t
              :custom ((imenu-list-size . 30)
                       (imenu-list-position . 'left))))

  (leaf macrostep
        :ensure t
        :bind (("C-c e" . macrostep-expand)))

  (leaf cus-edit
        :doc "tools for customizing Emacs and Lisp packages"
        :tag "builtin" "faces" "help"
        :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

  ;;; ここに各自好きな設定を書く
  (leaf doom-themes
        :doc "An opinionated pack of modern color-themes."
        :req "emacs-25.1" "cl-lib-0.5"
        :tag "faces" "themes" "emacs>=25.1"
        :url "https://github.com/doomemacs/themes"
        :ensure t
        :config
        (load-theme 'doom-dark+ t)
        (set-frame-parameter nil 'alpha 92))     

(set-frame-font "Gen Interface JP 18")
;; (setq default-font-size 18)

;; 相対的な行番号を表示
(setq display-line-numbers-type t)
(setq display-line-numbers-width 4)
(setq display-line-numbers-width-start nil)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-grow-only t)
(setq toggle-truncate-lines nil)
;; 行番号のフォントを明確に等幅（例: Courierやmonospace）に固定する

(set-face-attribute 'line-number nil
                    :font "BIZ UDGothic" ; お好みの等幅フォントを指定
                    :height 1.0)       ; 本文のサイズと合わせる場合
(set-face-attribute 'line-number-current-line nil
                    :font "BIZ UDGothic"
                    :height 1.0)

;; clipboard integration
(setq x-select-enable-clipboard t)

;; (leaf tab-bar-mode
;;     :init
;;     (define-key global-map (kbd "C-<up>") 'tab-bar-switch-to-prev-tab)
;;     (define-key global-map (kbd "C-<down>") 'tab-bar-switch-to-next-tab)
;;     (define-key global-map (kbd "C-t") 'tab-bar-new-tab)
;;     (define-key global-map (kbd "C-w") 'tab-bar-close-tab)
;;     :custom
;;     ((tab-bar-new-tab-choice . "*scratch*"))
;;     :config
;;     (tab-bar-mode t)
;;     (face-spec-set 'tab-bar-tab '((((background light)) (:background "gold")) (((background dark)) (:background "#808080")))))

(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
    ("\\.txt$" . indented-text-mode)
    ("nifty.[a-z]*$" . xcscript-mode)
    ("jyusyo\\.sgm$" . ramdb-mode)
    ("pad[0-9]$" . nifty-post-mode)
    ("\\.html$" . yahtml-mode)
    ("\\.rb$" . ruby-mode)
    ("lib[0-9][0-9]$" . qlog-library-mode)
    ("/lib$" . qlog-library-forum-mode)
    ("\\.md$" . markdown-mode)
    ("\\.pov$" . pov-mode))
        auto-mode-alist))

;; init/ ディレクトリ内のファイルをすべて読み込む
(let ((init-dir (expand-file-name "init" user-emacs-directory)))
  (when (file-directory-p init-dir)
    (dolist (f (directory-files init-dir t "\\.el$"))
      (load f nil t))))

(provide 'init)
