;; -*- lexical-binding: t; -*-
;; GC 启动优化
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold (* 8 100 100)
          gc-cons-percentage 0.1)))

(setq package-check-signature nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")))

;;(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
;;                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))


;; 隐藏UI
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(setq auto-revert-interval 1)
(setq revert-without-query '(".*"))

(setq make-backup-files t)
(setq inhibit-startup-screen t
      initial-scratch-message ""
      )
(setq display-line-numbers-type 'relative)

(setq custom-file "~/.emacs.d/custom.el")
(load-file custom-file)


(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-15"))

(electric-pair-mode 1)
(fido-vertical-mode 1)
(global-company-mode 1)

(use-package which-key
  :config (which-key-mode 1))

(use-package eglot
  :bind (:map eglot-mode-map
              ("C-c e f" . eglot-format-buffer)
              ("C-c e r" . eglot-rename)
              ("C-c e a" . eglot-code-actions))
  ;; 在编程模式（含各类 ts-mode）和 HTML 模式（含 .vue 文件）下自动尝试启动 Eglot
  :hook ((prog-mode . eglot-ensure)
         (html-mode . eglot-ensure))
  :custom
  ;; Disable event logging to eliminate memory leaks and overhead.
  (eglot-events-buffer-size 0)
  ;; Faster response time for completion and diagnostics.
  (eglot-send-changes-idle-time 0.15)
  ;; Automatically shutdown LSP server when all project buffers are closed.
  (eglot-autoshutdown t)
  :config
  ;; 指定 Python 使用 ty server (python-base-mode 同时覆盖 python-mode 与 python-ts-mode)
  (add-to-list 'eglot-server-programs '(python-base-mode "ty" "server"))
  ;; 配置 Vue 与 TS/JS 使用 vtsls（优先选择 vtsls，若未安装则降级回 vue-language-server）
  (add-to-list 'eglot-server-programs
               `((html-mode typescript-mode typescript-ts-mode js-mode js-ts-mode)
                 . ,(eglot-alternatives
                     '(("vtsls" "--stdio")
                       ("vue-language-server" "--stdio"))))))

(defun open-init-file ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f2>") 'open-init-file)



;; 保留原生M-x备用
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;; C模式默认使用//单行注释
(add-hook 'c-mode-hook
          (lambda () (c-toggle-comment-style -1)))


(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

(require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(require 'dired-x)
;; 默认隐藏所有.开头隐藏文件
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
;; 双窗口拖拽复制/移动文件
(setq-default dired-dwim-target t)
;; ls显示人类可读文件大小
(setq dired-listing-switches "-alh")
;; 鼠标拖拽文件
(setq dired-mouse-drag-files t)

(require 'magit)
(setq magit-auto-revert-mode nil)
(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

; (require 'helm)
; (setq helm-ff-transformer-show-only-basename nil)
; (global-set-key (kbd "C-c h t") 'helm-cmd-t)
; (global-set-key (kbd "C-c h g g") 'helm-git-grep)
; (global-set-key (kbd "C-c h f") 'helm-find)
; (global-set-key (kbd "C-c h r") 'helm-recentf)
