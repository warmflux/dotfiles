;; straight.el 引导代码，必须放在配置文件第一行
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

;; 绑定 use-package，所有 use-package 自动用 straight 安装
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
;; 浅克隆加速，复刻Doom默认配置
(setq straight-vc-git-default-clone-depth 1)

;; 插件加载

;;vim复刻
(use-package evil
  :init
  ;; 加载前全局参数
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-undo-system 'undo-redo) ; Emacs28+ 原生撤销，替换undo-tree
  :config
  (evil-mode 1) ; 全局开启Vim模态
  ;; org RET 跳转修复
  (with-eval-after-load 'evil-maps
    (define-key evil-motion-state-map (kbd "RET") nil))
  ;; 光标：三种状态统一 box（实心方块），每态一个颜色字符串
  ;; cursor 变量存颜色字符串即可，evil 会把形状交给默认 box、
  ;; 颜色用 set-cursor-color 单独上（evil-refresh-cursor 就是这么拆的）
  (setq evil-normal-state-cursor "#ffffff"
        evil-insert-state-cursor "#4cc9f0"   ; 插入=蓝色
        evil-visual-state-cursor "#b19cd9")  ; 视觉选中=紫色
  (evil-refresh-cursor))
  


(use-package evil-escape
  :after evil
  :config
  ;; 配置双按键退出插入模式，二选一，推荐jk（Vim传统）
  (setq evil-escape-key-sequence "jk")
  ;; (setq evil-escape-key-sequence "fd")
  ;; 按键间隔阈值：200ms内连续按下才触发
  (setq evil-escape-delay 0.2)
  ;; 全局开启
  (evil-escape-mode 1))

(use-package evil-collection
  :after evil
  :config
  ;; 移除冲突插件lispy
  (setq evil-collection-mode-list (remove 'web-mode evil-collection-mode-list))
  (setq evil-collection-mode-list (remove 'lispy evil-collection-mode-list))
  (evil-collection-init)
  ;; 指定buffer默认进入normal模式
  (cl-loop for (mode . state) in
           '((org-agenda-mode . normal)
             (Custom-mode . emacs)
             (eshell-mode . emacs)
             (makey-key-mode . motion))
           do (evil-set-initial-state mode state)))

;; ============================================================
;; 括号配对：smartparens（复刻 Doom :config default 的默认行为）
;;   - 全局开启配对/成对删除，少数模式禁用（+smartparens-blacklist）
;;   - 不做 ++smartparens 的语言级 sp-pair 花活（需要时再加）
;; ============================================================
(defvar +smartparens-blacklist
  '(minibuffer-inactive-mode help-mode
    ;; 终端/制表类模式开括号配对纯属添乱
    term-mode vterm-mode comint-mode)
  "禁掉 smartparens 的 major-mode 列表（照 Doom 的 +smartparens-disable 思路）。")

(use-package smartparens
  :straight t
  :config
  (require 'smartparens-config)
  ;; Doom 的取值：关掉高亮/字符串内自动逃逸，前缀后缀过长无所谓
  (setq sp-highlight-pair-overlay nil
        sp-autoescape-string-quote nil)
  ;; 全局启用
  (smartparens-global-mode +1)
  ;; minibuffer 里关掉（Doom 同款）
  (add-hook 'minibuffer-setup-hook #'turn-off-smartparens-mode)
  ;; 黑名单：进了这些模式就把 smartparens 关了
  (defun +smartparens-disable-in-buffer-h ()
    (when (memq major-mode +smartparens-blacklist)
      (smartparens-mode -1)))
  (add-hook 'change-major-mode-after-body-hook #'+smartparens-disable-in-buffer-h))


;; 搜索高亮计数
(use-package evil-anzu
  :after evil
  :diminish
  :config
  (global-anzu-mode t))

;; 括号/引号快速增删改 cs"' ds(
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

;; 注释快捷键 ,/
(use-package evil-nerd-commenter
  :after evil
  :config
  (define-key evil-normal-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
  (define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines))

;; f/F 快速字符跳转
(use-package evil-snipe
  :after evil
  :diminish
  :config
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1))

;; % 匹配括号跳转增强
(use-package evil-matchit
  :after evil
  :config
  (global-evil-matchit-mode 1))


;; ============================================================
;; general + which-key：复刻 Doom 的 leader key 体系
;; ------------------------------------------------------------
;; general 是声明式绑定 DSL，which-key 提供 SPC 按下后的弹层
;; 菜单，general-override-mode 让绑定压过默认 keymap。
;; ============================================================

(use-package general
  :after evil
  :config
  ;; 让 general 认识 evil，:states 才有意义（必须在 evil 之后加载）
  (general-evil-setup t)
  ;; SPC 主 prefix（等价于 Doom 的 doom-leader-key）
  ;; 注意：必须给 :prefix-command，否则 SPC 会被绑成 nil（非 prefix），
  ;; 无法定义 SPC SPC 这类"以 prefix 自身开头"的按键
  (general-create-definer doom/leader-def
    :prefix "SPC"
    :non-normal-prefix "M-SPC"      ; insert/emacs 态用 M-SPC
    :states '(normal visual motion)
    :prefix-command 'doom/leader)

  ;; SPC m 局部 prefix（等价于 Doom 的 doom-localleader-key，
  ;; 每个 major-mode 各自定义自己的按键）
  (general-create-definer doom/localleader-def
    :prefix "SPC m"
    :non-normal-prefix "M-SPC m"
    :states '(normal visual motion)
    :prefix-command 'doom/localleader)
  ;; 覆盖模式：让 general 的绑定压过插件默认 keymap（复刻 Doom）
  (general-override-mode 1)

  ;; SPC f d → 打开配置目录（~/.emacs.d）
  (defun my/open-config-dir ()
    (interactive)
    (dired user-emacs-directory))

  ;; SPC p / → 在项目根目录用 ripgrep 搜索（复刻 Doom `+vertico/project-search'）
  ;; 前缀 C-u 时带上隐藏文件/目录（-uu）
  (defun my/project-ripgrep (&optional arg)
    (interactive "P")
    (let* ((root (or (and (fboundp 'project-root)
                          (let ((pr (project-current))) (and pr (project-root pr))))
                     default-directory))
           (consult-ripgrep-args
            (if arg (concat consult-ripgrep-args " -uu") consult-ripgrep-args)))
      (consult-ripgrep root)))

  ;; ===== SPC s 搜索分组（复刻 Doom :config default 的 `+default/search-*'） =====

  ;; SPC s s / s b → 搜当前 buffer：带选区且跨行→只搜选区；
  ;; 带选区但单行→把选区当初始输入搜全 buffer
  (defun my/search-buffer ()
    (interactive)
    (let (start end multiline-p)
      (save-restriction
        (when (region-active-p)
          (setq start (region-beginning)
                end   (region-end)
                multiline-p (/= (line-number-at-pos start)
                                (line-number-at-pos end)))
          (deactivate-mark)
          (when multiline-p
            (narrow-to-region start end)))
        (if (and start end (not multiline-p))
            (consult-line
             (replace-regexp-in-string
              " " "\\\\ "
              (regexp-quote (buffer-substring-no-properties start end))))
          (consult-line)))))

  ;; SPC s S → 搜当前 buffer 里的光标词
  (defun my/search-symbol-at-point ()
    (interactive)
    (consult-line (thing-at-point 'symbol)))

  ;; SPC s d → 当前目录 ripgrep；C-u → 让你挑别的目录
  (defun my/search-cwd (&optional arg)
    (interactive "P")
    (let ((dir (if arg (read-directory-name "Search directory: ") default-directory)))
      (consult-ripgrep dir)))

  ;; SPC s e → 在 ~/.emacs.d（配置文件目录）里 ripgrep
  (defun my/search-emacsd ()
    (interactive)
    (consult-ripgrep user-emacs-directory))

  ;; SPC s B → 在所有打开的 buffer 里搜行
  (defun my/search-buffers ()
    (interactive)
    (consult-line-multi 'all-buffers))

  ;; SPC * → 项目里搜光标词（复刻 `+default/search-project-for-symbol-at-point'）
  (defun my/search-project-symbol-at-point (&optional arg)
    (interactive "P")
    (let* ((root (or (and (fboundp 'project-root)
                          (let ((pr (project-current))) (and pr (project-root pr))))
                     default-directory))
           (consult-ripgrep-args
            (if arg (concat consult-ripgrep-args " -uu") consult-ripgrep-args)))
      (consult-ripgrep root (thing-at-point 'symbol t))))

  ;; ========= 所有 SPC Leader 绑定全部写在这里！！ =========
  ;; 不要放到其他use-package的:config里！！
  (doom/leader-def
    "SPC" 'execute-extended-command    ; SPC SPC → M-x
    "!"   'shell-command               ; SPC ! → shell命令
    ;; git分组
    "g"   '(:ignore t :wk "git")
    "gs"  #'magit-status
    "gl"  #'magit-log-current-buffer
    ;; help分组
    "h"   '(:ignore t :wk "help")
    "hdk" #'describe-key
    "hdf" #'describe-function
    "hdv" #'describe-variable
    ;; buffer分组
    "b"   '(:ignore t :wk "buffer")
    "bb"  #'consult-buffer
    "bd"  #'kill-current-buffer
    "bn"  #'next-buffer
    "bp"  #'previous-buffer
    ;; window分组
    "w"   '(:ignore t :wk "window")
    "ws"  #'evil-window-split
    "wv"  #'evil-window-vsplit
    "wd"  #'evil-window-delete
    "wo"  #'delete-other-windows
    "wh"  #'evil-window-left
    "wj"  #'evil-window-down
    "wk"  #'evil-window-up
    "wl"  #'evil-window-right
    ;; file分组
    "f"   '(:ignore t :wk "file")
    "ff"  #'find-file                     ; SPC f f → find-file（vertico+orderless 增强）
    "fc"  #'my/open-config-dir         ; SPC f c → 配置目录
    "fp"  #'project-dired              ; SPC f p → 当前文件的项目根目录
    "fs"  #'save-buffer
    ;; project分组
    "p"   '(:ignore t :wk "project")
    "p/"  #'my/project-ripgrep         ; SPC p / → 项目里 rg 搜代码
    "pf"  #'project-find-file          ; SPC p f → 项目里找文件（模糊匹配）
    ;; search分组（复刻 Doom SPC s：搜索一切）
    "s"   '(:ignore t :wk "search")
    "s/"  #'my/project-ripgrep              ; 项目里搜代码
    "sb"  #'my/search-buffer                ; 搜当前 buffer（沿选区）
    "sB"  #'my/search-buffers               ; 所有打开的 buffer 里搜行
    "sd"  #'my/search-cwd                   ; 当前目录搜，C-u 选目录
    "se"  #'my/search-emacsd                ; 配置文件目录里搜
    "sf"  #'locate
    "si"  #'consult-imenu                   ; 当前 buffer 跳符号
    "sI"  #'consult-imenu-multi             ; 全 buffer 跳符号
    "sj"  #'evil-show-jumps
    "sm"  #'bookmark-jump
    "sp"  #'my/project-ripgrep
    "sr"  #'evil-show-marks
    "ss"  #'my/search-buffer
    "sS"  #'my/search-symbol-at-point
    ;; SPC /（项目搜索）和 SPC *（搜光标词）是 Doom 的顶层搜索键
    "/"   #'my/project-ripgrep
    "*"   #'my/search-project-symbol-at-point
    ;; code分组（eglot/LSP，复刻 Doom SPC c）
    "c"   '(:ignore t :wk "code")
    "ca"  #'eglot-code-actions
    "cr"  #'eglot-rename
    "cd"  #'xref-find-definitions
    "cD"  #'xref-find-references
    "ci"  #'eglot-find-implementation
    "ct"  #'eglot-find-typeDefinition
    "ck"  #'eldoc-doc-buffer
    "cj"  #'eglot-find-declaration
    "cf"  #'eglot-format-buffer
    "cx"  #'flymake-show-buffer-diagnostics
    "cS"  #'consult-eglot-symbols
    ))

  ;; ========= vim 风格 `g` 前缀跳转（复刻 Doom editor/evil 的 :nv "gd"/"gD"） =========
  ;; 覆写 evil 自带 `gd'（etags），改为 xref/eglot 版；没连 LSP 时 xref 也能
  ;; 退回 etags。只挑这俩不撞 evil 默认键的（g t=tab、g j/g k=行内上下、
  ;; g a/g i 等都已被占）
  (general-define-key
   :states '(normal visual)
   "gd" #'xref-find-definitions
   "gD" #'xref-find-references
   ;; H/L 行首/行尾（覆写 evil 默认 H=窗口顶、L=窗口底；要窗口顶/底用
   ;; 原来的 `H'/`L' 就没了，可改用 M-... 或删这几行恢复）
   "H"  #'evil-first-non-blank   ; 行首（第一个非空白字符，Vim 的 ^）
   "L"  #'evil-end-of-line)      ; 行尾（Vim 的 $）

  ;; 局部leader示例 SPC m
  (doom/localleader-def
    "r" '(:ignore t :wk "run"))



;; magit 只负责安装，不再写任何leader绑定！
(use-package magit
  :after evil-collection)


;; ============================================================
;; 代码补全：corfu + orderless + cape（复刻 Doom :completion corfu）
;; ------------------------------------------------------------
;; corfu      弹出候选条；orderless 模糊匹配；cape 补全适配器
;; ============================================================

(use-package corfu
  :hook (after-init . global-corfu-mode)
  :config
  (setq corfu-auto t                  ; 输入即弹
        corfu-auto-delay 0.24         ; 停顿多久触发
        corfu-auto-prefix 2           ; 敲满2字符才触发
        corfu-cycle t                 ; TAB 循环候选
        corfu-preselect 'prompt
        corfu-count 16                ; 最多显示多少候选
        corfu-max-width 120
        corfu-on-exact-match nil
        ;; orderless 模式下用空格分段，靠后补全不打断输入
        corfu-quit-at-boundary 'separator)
  ;; 退出插入模式时收起候选条
  (add-hook 'evil-insert-state-exit-hook #'corfu-quit)
  ;; 候选历史记录（记忆常用词）
  (savehist-mode 1)
  (corfu-history-mode 1)
  (add-to-list 'savehist-additional-variables 'corfu-history)
  ;; 候选旁显示文档
  ;; 延迟拉长到 Doom 的节奏：默认 (0.2 . 0.1) 一悬停就向 LSP 发起
  ;; textDocument/hover，逐个候选拉文档会把补全刷出卡顿感
  (setq corfu-popupinfo-delay '(0.6 . 0.8))
  (corfu-popupinfo-mode 1))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles orderless partial-completion)))
        ;; 空格为组件分隔符（可转义），find-file 里不影响路径
        orderless-component-separator #'orderless-escapable-split-on-space)

  ;; 特殊前缀触发不同匹配（复刻 Doom vertico 模块）：
  ;;   ! 禁止字面量   & 只看注解   % 等价字符折叠
  ;;   ` 首字母缩写   = 字面量      ^ 字面量前缀   ~ 模糊
  (setq orderless-affix-dispatch-alist
        '((?! . orderless-without-literal)
          (?& . orderless-annotation)
          (?% . char-fold-to-regexp)
          (?` . orderless-initialism)
          (?= . orderless-literal)
          (?^ . orderless-literal-prefix)
          (?~ . orderless-flex))
        orderless-style-dispatchers
        '(+my-orderless-dispatch +my-orderless-disambiguation-dispatch))

  ;; 复刻 Doom 的 `+vertico-orderless-dispatch'：支持被转义的后缀匹配
  (defun +my-orderless-dispatch (pattern _index _total)
    (let ((len (length pattern))
          (alist orderless-affix-dispatch-alist))
      (when (> len 0)
        (cond
         ((and (= len 1) (alist-get (aref pattern 0) alist)) #'ignore)
         ((when-let* ((style (alist-get (aref pattern 0) alist))
                      ((not (char-equal (aref pattern (max (1- len) 1)) ?\\))))
            (cons style (substring pattern 1))))
         ((when-let* ((style (alist-get (aref pattern (1- len)) alist))
                      ((not (char-equal (aref pattern (max 0 (- len 2))) ?\\))))
            (cons style (substring pattern 0 -1))))))))

  ;; 复刻 Doom 的 `+vertico-orderless-disambiguation-dispatch'：
  ;; 让 consult 加了 tofu/disambiguation 后缀时 $ 仍按正则结尾匹配
  (defun +my-orderless-disambiguation-dispatch (word _index _total)
    (let ((tofu-re (if (boundp 'consult--tofu-regexp)
                       (concat consult--tofu-regexp "*\\'")
                     "\\'")))
      (cond
       ((string-suffix-p "$" word)
        `(orderless-regexp . ,(concat (substring word 0 -1) tofu-re)))
       ((string-suffix-p "/" word) '(orderless-regexp . "\\`")))
      )))

(use-package cape
  :config
  ;; prog-mode 一律补文件路径（补全 include/dev-dependency）
  (add-hook 'prog-mode-hook
            (lambda () (add-hook 'completion-at-point-functions #'cape-file -10 t)))
  ;; 全局兜底：补全缓冲区里已有的词
  (add-hook 'prog-mode-hook
            (lambda () (add-hook 'completion-at-point-functions #'cape-dabbrev 20 t)))
  (with-eval-after-load 'eglot
    (advice-add #'eglot-completion-at-point :around #'cape-wrap-nonexclusive))
  (with-eval-after-load 'comint
    (advice-add #'comint-completion-at-point :around #'cape-wrap-nonexclusive)))


;; ============================================================
;; minibuffer 补全：vertico + consult + marginalia
;; （Doom :completion vertico 模块的轻量版）
;; ------------------------------------------------------------
;; vertico       M-x / find-file 的纵向候选列表
;; consult       检索/跳转类命令的增强版（buffer、grep、imenu…）
;; marginalia    候选右侧的注解（文件大小/模式/文档摘要）
;; 与 corfu 分工：corfu 管『编辑区内候选条』，vertico 只碰 minibuffer，
;; 两者互不干扰。注意：不要设置 completion-in-region-function——
;; 那会把编辑区补全从 corfu 切到 vertico，而我们两个都要。
;; ============================================================

(use-package vertico
  :straight (vertico :type git :host github :repo "minad/vertico"
                     :pin "cd2eb6daff6a5a68a11740aa363729ec6f8702d3")
  :hook (after-init . vertico-mode)
  :config
  (setq vertico-resize nil          ; 候选多时列表变高而非缩成一行
        vertico-count 17
        vertico-cycle t)            ; TAB/循环回绕（Doom 同款）
  ;; 文件路径 shadow 折叠：~/foo/bar/../ 自动清理成 /
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  ;; 在文件选择里 DEL 删一段路径而不是一个字符（Doom 同款）
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
  ;; C-j/C-k 上下移动（evil 风格，就按 Doom 绑）
  (define-key vertico-map (kbd "C-j") #'vertico-next)
  (define-key vertico-map (kbd "C-k") #'vertico-previous))

(use-package consult
  :straight (consult :type git :host github :repo "minad/consult"
                     :pin "3a2441ddb08d9897eb266cda4935fa91a767e1d5")
  :defer t
  :init
  ;; 常用命令整体替换成 consult 增强版（Doom 同款 remap）
  (define-key global-map [remap bookmark-jump]      #'consult-bookmark)
  (define-key global-map [remap goto-line]          #'consult-goto-line)
  (define-key global-map [remap imenu]              #'consult-imenu)
  (define-key global-map [remap load-theme]         #'consult-theme)
  (define-key global-map [remap recentf-open-files] #'consult-recent-file)
  (define-key global-map [remap switch-to-buffer]   #'consult-buffer)
  (define-key global-map [remap switch-to-buffer-other-window]
    #'consult-buffer-other-window)
  (define-key global-map [remap yank-pop]           #'consult-yank-pop)
  :config
  (setq consult-narrow-key "<"
        consult-async-min-input 2      ; 异步检索输入2字符起步
        consult-async-refresh-delay 0.15
        consult-async-input-throttle 0.2
        consult-async-input-debounce 0.1)
  ;; 检索类命令统一在 C-SPC 上 preview（Doom 同款）
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
   consult-source-recent-file consult-source-project-recent-file consult-source-bookmark
   :preview-key "C-SPC")
  (consult-customize consult-theme :preview-key '("C-SPC" :debounce 0.5 any))
  ;; consult-buffer/recent-file 依赖 recentf-mode，自动开
  (advice-add #'consult-recent-file :before (lambda (&rest _) (recentf-mode +1)))
  (advice-add #'consult-buffer :before (lambda (&rest _) (recentf-mode +1))))

(use-package marginalia
  :straight (marginalia :type git :host github :repo "minad/marginalia"
                        :pin "d76d7e36185ab552240c14fb08f7abcbf9a2910c")
  :hook (after-init . marginalia-mode)
  :config
  ;; 循环切换注解详细度（minibuffer 里按 M-A）
  (define-key minibuffer-local-map (kbd "M-A") #'marginalia-cycle))

;; eglot 工作区符号搜索（SPC c S），复刻 Doom tools/lsp +eglot 的
;; `consult-eglot'（[remap xref-find-apropos] 也一并换成 consult 版）
;; 坑已踩过：consult-eglot 头里 Package-Requires 声明了 (eglot "1.16")
;; (project "0.3.0")，straight 会据此从 melpa/emacs-straight 克隆 eglot+
;; project+xref+eldoc+flymake+jsonrpc 一堆老包，把 Emacs 30 内建的同名包
;; 全部遮蔽（eglot-find-typeDefinition 等新函数全没了）。已在 clone 下来的
;; consult-eglot.el 里把这两项依赖删掉、build 目录删掉让 straight 重建。
;; 万一以后 pull 后 eglot 又冒出来，照这个思路处理。
(use-package consult-eglot
  :straight (consult-eglot :type git :host github :repo "mohkale/consult-eglot"
                           :files (:defaults "*.el")
                           :depends (consult))
  :after eglot
  :defer t
  :config
  (general-define-key
   :states '(normal visual)
   :keymaps 'eglot-mode-map
   [remap xref-find-apropos] #'consult-eglot-symbols))


;; ============================================================
;; 编程语言模式（Emacs 30 把 go-mode 删了，只剩 tree-sitter 版，
;; 但 auto-mode-alist 里没有 .go 条目 → main.go 打开会落到
;; fundamental-mode，无色、eglot/补全全失效；手动补上映射）
;; ------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\(?:go\\.mod\\|go\\.work\\)\\'" . go-mod-ts-mode))
;; java：默认 .java 走 cc-mode 的 java-mode，换 tree-sitter 版
;; 语法 lib 在 ~/.emacs.d/tree-sitter/libtree-sitter-java.so（已手动编译）
(add-to-list 'auto-mode-alist '("\\.java\\'" . java-ts-mode))
;; rust/.ts/.tsx：Emacs 30 "默认"映射其实只在模式文件加载后、且语法就绪时才
;; 登记（文件尾 `(if (treesit-ready-p ...) (add-to-list ...))`）；首次打开
;; 对应扩展名前 auto-mode-alist 查无此项 → 落 fundamental-mode。这里显式补上。
;; 语法 lib 已编译到 ~/.emacs.d/tree-sitter/
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.\\(?:mts\\|cts\\)\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode))
;; ------------------------------------------------------------
;; 缩进：2 空格（编辑器自动缩进 + LSP 格式化共用）
;;   - tab-width/indent-tabs-mode 会被 eglot 直接塞进 LSP 的
;;     formattingOptions（tabSize/insertSpaces），所以对
;;     tsls/jdtls 这类尊重客户端参数的 server，"格式化"也是 2 空格
;;   - 例外：rustfmt 无视客户端缩进（固定 4 空格，除非项目 rustfmt.toml
;;     里设 tab_spaces）；gofmt 固定 tab 制表，改不了
;; ------------------------------------------------------------
(setq-default tab-width 2
              indent-tabs-mode nil)    ; 一律空格，不混 tab
(dolist (var '(typescript-ts-mode-indent-offset
               tsx-ts-mode-indent-offset
               rust-ts-mode-indent-offset
               java-ts-mode-indent-offset
               json-ts-mode-indent-offset
               go-ts-mode-indent-offset))
  (when (boundp var)
    (set var 2)))

;; ============================================================
;; LSP：eglot（Emacs 30 内建，复刻 Doom :tools lsp +eglot）
;; ------------------------------------------------------------
;; 在项目里 M-x eglot 或者直接打开带 LSP 的文件即可连接。
;; 常用命令：M-x eglot、M-x eglot-format、M-x eglot-code-actions
;; ============================================================

(use-package eglot
  :straight nil                     ; Emacs 30 自带，不用装
  :commands eglot eglot-ensure eglot-format-buffer eglot-code-actions
           eglot-rename eglot-find-implementation eglot-find-typeDefinition
           eglot-find-declaration eglot-format
  :hook (eglot-managed-mode . (lambda ()
                                ;; LSP 大文件下相对行号每次改动都要重算，是刷新热点；
                                ;; 降级成绝对行号省掉这一堆 renumber 工作
                                (setq-local display-line-numbers-type 'absolute)
                                ;; mode-line 的 which-func 每帧都查一次 xref，费电
                                (setq-local which-func-mode -1)))
  :config
  (setq eglot-sync-connect 0        ; 异步连接，不卡输入
        eglot-autoshutdown t        ; buffer 全关自动杀 server
        eglot-max-file-watches 5000
        eglot-auto-display-help-buffer nil
        eglot-code-action-indications '(eldoc-hint)
        eglot-events-buffer-config '(:size 0))  ; 关调试buffer省CPU/GC
  ;; Java LSP 复用 nvim/mason 装好的 jdtls（不重复下载）：
  ;;   ~/.local/share/nvim/mason/bin/jdtls → packages/jdtls/bin/jdtls（python 脚本）
  ;; jdtls 必须给 -data 工作区目录，否则在随机目录建索引；
  ;; ms-pair 不传（eglot 自动加 --stdio）。
  (add-to-list 'eglot-server-programs
               `(java-ts-mode . (,(expand-file-name "~/.local/share/nvim/mason/bin/jdtls")
                                 "-data" "/tmp/jdtls-workspace")))
  (add-to-list 'eglot-server-programs
               `(java-mode . (,(expand-file-name "~/.local/share/nvim/mason/bin/jdtls")
                              "-data" "/tmp/jdtls-workspace")))
  ;; Rust：rustup 装的 rust-analyzer（~/.cargo/bin/rust-analyzer，不是新下载）
  (add-to-list 'eglot-server-programs
               `(rust-ts-mode . (,(expand-file-name "~/.cargo/bin/rust-analyzer"))))
  ;; TypeScript/TSX：复用 nvim/mason 的 typescript-language-server（带 tsserver）
  (dolist (mode '(typescript-ts-mode tsx-ts-mode))
    (add-to-list 'eglot-server-programs
                 `(,mode . (,(expand-file-name "~/.local/share/nvim/mason/bin/typescript-language-server")
                            "--stdio"))))
  ;; Go：eglot 默认表里只有 go-mode，没有 go-ts-mode/go-mod-ts-mode，
  ;; 路径不发 gopls → 打开 .go 从不自动连。复用 mason 的 gopls。
  (dolist (mode '(go-ts-mode go-mod-ts-mode))
    (add-to-list 'eglot-server-programs
                 `(,mode . (,(expand-file-name "~/go/bin/gopls")))))
  ;; 打开支持 Eglot 的语言文件时自动连 server。
  ;; 不直接挂 eglot-ensure 而是先查 eglot-server-programs：prog-mode 里有些
  ;; 模式（如 fundamental-mode 兜底、未装载 tree-sitter 语法时）无 server 对应，
  ;; 盲目 eglot-ensure 会产生 "Connected! server now managing `nil' buffers"
  ;; 这类"连接成功但一个 buffer 都没托管"的空连接。
  (add-hook 'prog-mode-hook
            (lambda ()
              (when (and buffer-file-name (eglot--lookup-mode major-mode))
                (eglot-ensure)))))




;; ============================================================
;; 主题：doom-themes（复刻 Doom :ui doom）
;; 换主题改下面 doom-theme 的名字即可，可选：
;;   doom-one（默认）/ doom-dracula / doom-nord / doom-gruvbox
;;   doom-palenight / doom-laserwave / doom-monokai-pro ...
;; ============================================================
(use-package doom-themes
  :straight (doom-themes :type git :host github :repo "doomemacs/themes"
                         :files (:defaults "themes/*.el" "themes/*/*.el" "extensions/*.el"))
  :config
  (setq doom-theme 'doom-one)
  (doom-themes-org-config)   ; org 模式脸型/配色微调
  (load-theme doom-theme t))

;; ============================================================
;; 图标字体：nerd-icons（doom-modeline / corfu 图标的后端）
;; 首次需装字体：M-x nerd-icons-install-fonts（需要联网下载一次）
;; ============================================================
(use-package nerd-icons
  :straight (nerd-icons :type git :host github :repo "rainstormstudio/nerd-icons.el"))

;; ============================================================
;; 状态栏：doom-modeline（复刻 Doom :ui modeline 的默认取值）
;; ============================================================
(use-package doom-modeline
  :straight (doom-modeline :type git :host github :repo "seagle0128/doom-modeline")
  :hook (after-init . doom-modeline-mode)
  :config
  ;; 默认取 Doom :ui modeline 的取值：去掉 github/mu4e/persp/次要模式
  ;; 一些冗余字段，只留代码里真正当用的
  (setq doom-modeline-bar-width 3
        doom-modeline-github nil
        doom-modeline-mu4e nil
        doom-modeline-persp-name nil
        doom-modeline-minor-modes nil
        doom-modeline-major-mode-icon nil
        doom-modeline-check 'simple    ; check 状态太吵，只留记号
        ;; 文件名相对项目根显示（长路径不刷屏）
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-buffer-encoding 'nondefault))

;; ============================================================
;; 字体：直接用系统里的 JetBrainsMono Nerd Font（已含图标字形，
;; nerd-icons 不需要再额外下载 Symbols 字体）
;; ============================================================
(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 150)   ; 12pt，嫌大/嫌小改这个数

;; 光标/背景适配主题
(setq x-stretch-cursor t
      frame-background-mode 'dark)

;; 关闭顶部菜单栏
(menu-bar-mode -1)

;; 关闭工具栏，tool-bar-mode 即为一个 Minor Mode
(tool-bar-mode -1)

;; 关闭文件滑动控件
(scroll-bar-mode -1)

;; 鼠标滚轮/触控板逐像素平滑滚动（Emacs 30 内建，零依赖）
(pixel-scroll-precision-mode 1)

;; 显示行号
(global-display-line-numbers-mode 1)


(icomplete-mode -1)

(setq display-line-numbers-type 'relative) ; 相对行号（Doom默认）


;; 性能优化（复刻 Doom `doom-defer-garbage-collection'：加载期阈值放大撑过
;; 高峰；此后每次按键临时抬高、空闲 5 秒回落，避免"长期 100MB → 偶尔
;; 一次性大 GC 卡半秒"）
(defvar my/gc-cons-threshold (* 100 1024 1024)
  "按键期间使用的 GC 阈值。")
(defvar my/default-gc-cons-threshold (* 16 1024 1024)
  "空闲回落后的稳态 GC 阈值（Doom 默认值）。")
(defvar my/gc-idle-timer nil)

(setq gc-cons-threshold my/gc-cons-threshold ; 加载高峰用大阈值
      gc-cons-percentage 0.6)

(defun my/gc-bump ()
  "按键时抬高 GC 阈值，并重排 5 秒后的回落定时器。"
  (setq gc-cons-threshold my/gc-cons-threshold
        gc-cons-percentage 0.6)
  (when (timerp my/gc-idle-timer) (cancel-timer my/gc-idle-timer))
  (setq my/gc-idle-timer
        (run-at-time 5 nil
          (lambda ()
            (setq gc-cons-threshold my/default-gc-cons-threshold
                  gc-cons-percentage 0.1)))))

(add-hook 'post-command-hook #'my/gc-bump)

;; LSP 子进程缓冲区放大，避免大 JSON 响应分批接收造成卡顿
(setq read-process-output-max (* 1024 1024))

;; RTL 括号解析在大量引号/括号下偏贵，关掉（Doom 同款）
(setq bidi-inhibit-bpa t)

;; tree-sitter 高亮级别封顶 3（4 级会展开所有多语言引文，慢）
(setq treesit-font-lock-level 3)

;; 界面基础
(setq inhibit-startup-message t     ; 关闭欢迎页
      frame-resize-pixelwise t      ; 像素级窗口缩放
      window-combination-resize t)

;; 编码与文件
(setq default-file-name-coding-system 'utf-8
      default-process-coding-system '(utf-8 . utf-8))
(prefer-coding-system 'utf-8)
