;;; 10-clipboard.el --- system clipboard integration for terminal Emacs -*- lexical-binding: t; -*-
;;; Commentary:
;; GUI Emacs (X11/Wayland/NS) already syncs kill-ring with the system
;; clipboard via `select-enable-clipboard' (see init.el).
;; This file covers terminal Emacs (`emacs -nw', tmux, SSH, WSL) where
;; `display-graphic-p' is nil, by wiring `interprogram-cut-function' and
;; `interprogram-paste-function' to external tools when available.
;;
;; Priority: wl-copy/wl-paste (Wayland/niri/WSLg) > xclip (X11) > xsel (X11)
;;           > pbcopy/pbpaste (macOS) > clip.exe/powershell.exe (WSL interop)
;;           > OSC 52 escape sequence (SSH/tmux/ghostty fallback).
;;; Code:

(defun my-clipboard--wsl-p ()
  "Non-nil when running inside WSL."
  (or (getenv "WSL_DISTRO_NAME")
      (getenv "WSL_INTEROP")
      (and (eq system-type 'gnu/linux)
           (let ((v (ignore-errors (with-temp-buffer
                                     (insert-file-contents "/proc/version")
                                     (buffer-string)))))
             (and v (string-match-p "Microsoft" v))))))

(defun my-clipboard--call-process-region (program &rest args)
  "Send region text to PROGRAM with ARGS. Return t on success."
  (let ((status (apply #'call-process-region
                       (point-min) (point-max) program
                       nil nil nil args)))
    (and (numberp status) (zerop status))))

;; --- Wayland (niri / WSLg) ---
(defun my-clipboard-wl-copy (text)
  (when (executable-find "wl-copy")
    (with-temp-buffer
      (insert text)
      (my-clipboard--call-process-region "wl-copy" "--foreground" "--type" "text/plain"))))

(defun my-clipboard-wl-paste ()
  (when (executable-find "wl-paste")
    (let ((coding-system-for-read 'utf-8))
      (shell-command-to-string "wl-paste --no-newline --type text/plain 2>/dev/null"))))

;; --- X11 ---
(defun my-clipboard-xclip-copy (text)
  (when (executable-find "xclip")
    (with-temp-buffer
      (insert text)
      (my-clipboard--call-process-region "xclip" "-selection" "clipboard"))))

(defun my-clipboard-xclip-paste ()
  (when (executable-find "xclip")
    (let ((coding-system-for-read 'utf-8))
      (shell-command-to-string "xclip -selection clipboard -o 2>/dev/null"))))

(defun my-clipboard-xsel-copy (text)
  (when (executable-find "xsel")
    (with-temp-buffer
      (insert text)
      (my-clipboard--call-process-region "xsel" "--clipboard" "--input"))))

(defun my-clipboard-xsel-paste ()
  (when (executable-find "xsel")
    (let ((coding-system-for-read 'utf-8))
      (shell-command-to-string "xsel --clipboard --output 2>/dev/null"))))

;; --- macOS ---
(defun my-clipboard-pbcopy (text)
  (when (executable-find "pbcopy")
    (with-temp-buffer
      (insert text)
      (my-clipboard--call-process-region "pbcopy"))))

(defun my-clipboard-pbpaste ()
  (when (executable-find "pbpaste")
    (let ((coding-system-for-read 'utf-8))
      (shell-command-to-string "pbpaste 2>/dev/null"))))

;; --- WSL interop (Windows clipboard) ---
(defun my-clipboard-wsl-copy (text)
  (when (executable-find "clip.exe")
    (with-temp-buffer
      (insert text)
      ;; clip.exe expects CRLF/UTF-16; plain UTF-8 pipe works well enough.
      (my-clipboard--call-process-region "clip.exe"))))

(defun my-clipboard-wsl-paste ()
  (when (executable-find "powershell.exe")
    (let ((coding-system-for-read 'utf-8))
      (shell-command-to-string
       "powershell.exe -NoProfile -NonInteractive -Command Get-Clipboard 2>/dev/null"))))

;; --- OSC 52 fallback (SSH / tmux / ghostty / modern terminals) ---
(defun my-clipboard-osc52-copy (text)
  "Copy TEXT via OSC 52 escape sequence to the outer terminal."
  (when (and text (not (string= text "")))
    (send-string-to-terminal
     (concat "\e]52;c;"
             (base64-encode-string (encode-coding-string text 'utf-8) t)
             "\a"))
    ;; Return nil so Emacs keeps trying other handlers? No: report success
    ;; to avoid pasting stale content, but keep kill-ring intact.
    t))

(defun my-clipboard-terminal-copy (text)
  "Copy TEXT to the system clipboard from terminal Emacs."
  (cond
   ;; Wayland first: niri / WSLg sessions set WAYLAND_DISPLAY.
   ((and (or (getenv "WAYLAND_DISPLAY") (getenv "WAYLAND_SOCKET"))
         (executable-find "wl-copy"))
    (my-clipboard-wl-copy text))
   ((executable-find "wl-copy") (my-clipboard-wl-copy text))
   ((executable-find "xclip") (my-clipboard-xclip-copy text))
   ((executable-find "xsel") (my-clipboard-xsel-copy text))
   ((executable-find "pbcopy") (my-clipboard-pbcopy text))
   ((my-clipboard--wsl-p) (or (my-clipboard-wsl-copy text) (my-clipboard-osc52-copy text)))
   (t (my-clipboard-osc52-copy text))))

(defun my-clipboard-terminal-paste ()
  "Return system clipboard text for terminal Emacs, or nil."
  (let ((s (cond
            ((and (or (getenv "WAYLAND_DISPLAY") (getenv "WAYLAND_SOCKET"))
                  (executable-find "wl-paste"))
             (my-clipboard-wl-paste))
            ((executable-find "wl-paste") (my-clipboard-wl-paste))
            ((executable-find "xclip") (my-clipboard-xclip-paste))
            ((executable-find "xsel") (my-clipboard-xsel-paste))
            ((executable-find "pbpaste") (my-clipboard-pbpaste))
            ((my-clipboard--wsl-p) (my-clipboard-wsl-paste))
            (t nil))))
    (when (and s (> (length s) 0))
      ;; powershell.exe appends CRLF; normalize to LF.
      (replace-regexp-in-string "\r\n?" "\n" s))))

;; Only override interprogram functions on TTY frames. GUI frames keep the
;; built-in selection handling (which supports PRIMARY/CLIPBOARD properly).
(unless (display-graphic-p)
  (setq interprogram-cut-function #'my-clipboard-terminal-copy)
  (setq interprogram-paste-function #'my-clipboard-terminal-paste))

(provide '10-clipboard)
;;; 10-clipboard.el ends here
