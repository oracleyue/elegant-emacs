;; -------------------------------------------------------------------
;; Additional minimal Emacs native configurations to assist elegant-theme
;; Copyright 2020 Nicolas P. Rougier
;; -------------------------------------------------------------------

(require 'elegant-light-theme)

;;; Font and frame size
;;; -------------------------------------------------------------------
(setq default-frame-alist
      (append (list '(width  . 81) '(height . 45)
                    '(vertical-scroll-bars . nil)
                    '(internal-border-width . 24)
                    '(font . "Roboto Mono Light 14"))
              default-frame-alist))
(set-frame-parameter (selected-frame)
                     'internal-border-width 24)
;;; -------------------------------------------------------------------

;;; Line spacing, can be 0 for code and 1 or 2 for text
;;; -------------------------------------------------------------------
(setq-default line-spacing 0)
(setq x-underline-at-descent-line t)
(setq widget-image-enable nil)
;;; -------------------------------------------------------------------

;;; Line cursor and no blink
;;; -------------------------------------------------------------------
(set-default 'cursor-type  '(bar . 1))
(blink-cursor-mode 0)
;;; -------------------------------------------------------------------

;;; No sound
;;; -------------------------------------------------------------------
(setq visible-bell t)
(setq ring-bell-function 'ignore)
;;; -------------------------------------------------------------------

;;; No Tooltips
;;; -------------------------------------------------------------------
(tooltip-mode 0)
;;; -------------------------------------------------------------------

;;; Paren mode is part of the theme
;;; -------------------------------------------------------------------
(show-paren-mode t)
;;; -------------------------------------------------------------------

;;; When we set a face, we take care of removing any previous settings
;;; -------------------------------------------------------------------
(defun set-face (face style)
  "Reset a FACE and make it inherit STYLE."
  (set-face-attribute face nil
                      :foreground 'unspecified :background 'unspecified
                      :family     'unspecified :slant      'unspecified
                      :weight     'unspecified :height     'unspecified
                      :underline  'unspecified :overline   'unspecified
                      :box        'unspecified :inherit    style))
;;; -------------------------------------------------------------------

;;; Mode line rendering
;;; -------------------------------------------------------------------
;;; This line below makes things a bit faster
(set-fontset-font "fontset-default"  '(#x2600 . #x26ff) "Fira Code 16")

(define-key mode-line-major-mode-keymap [header-line]
  (lookup-key mode-line-major-mode-keymap [mode-line]))

(defun mode-line-render (left right)
  "Function to render the modeline LEFT to RIGHT."
  (let* ((available-width (- (window-width) (length left) )))
    (format (format "%%s %%%ds" available-width) left right)))
(setq-default mode-line-format
              '((:eval
                 (mode-line-render
                  (format-mode-line (list
                                     (propertize "☰" 'face `(:inherit mode-line-buffer-id)
                                                 'help-echo "Mode(s) menu"
                                                 'mouse-face 'mode-line-highlight
                                                 'local-map   mode-line-major-mode-keymap)
                                     " %b "
                                     (if (and buffer-file-name (buffer-modified-p))
                                         (propertize "(modified)" 'face `(:inherit face-faded)))))
                  (format-mode-line
                   (propertize "%4l:%2c" 'face `(:inherit face-faded)))))))
;;; -------------------------------------------------------------------

;;; Set modeline at the top
;;; -------------------------------------------------------------------
(setq-default header-line-format mode-line-format)
(setq-default mode-line-format'(""))
;;; -------------------------------------------------------------------

;;; Vertical window divider
;;; -------------------------------------------------------------------
(setq window-divider-default-right-width 3)
(setq window-divider-default-places 'right-only)
(window-divider-mode)
;;; -------------------------------------------------------------------

;;; Modeline
;;; -------------------------------------------------------------------
(defun elegant-set-modeline-faces ()
  "Mode line at top."
  (set-face 'header-line                                 'face-strong)
  (set-face-attribute 'header-line nil
                      :underline (face-foreground 'default))
  (set-face-attribute 'mode-line nil
                      :height 10
                      :underline (face-foreground 'default)
                      :overline nil
                      :box nil
                      :foreground (face-background 'default)
                      :background (face-background 'default))
  (set-face 'mode-line-inactive                            'mode-line)
  (set-face-attribute 'cursor nil
                      :background (face-foreground 'default))
  (set-face-attribute 'window-divider nil
                      :foreground (face-background 'mode-line))
  (set-face-attribute 'window-divider-first-pixel nil
                      :foreground (face-background 'default))
  (set-face-attribute 'window-divider-last-pixel nil
                      :foreground (face-background 'default)))
;;; -------------------------------------------------------------------

;;; Buttons
;;; -------------------------------------------------------------------
(defun elegant-set-button-faces ()
  "Set button faces."
  (set-face-attribute 'custom-button nil
                      :foreground (face-foreground 'face-faded)
                      :background (face-background 'face-subtle)
                      :box `(:line-width 1
                                         :color ,(face-foreground 'face-faded)
                                         :style nil))
  (set-face-attribute 'custom-button-mouse nil
                      :foreground (face-foreground 'default)
                      ;;; :background (face-foreground 'face-faded)
                      :inherit 'custom-button
                      :box `(:line-width 1
                                         :color ,(face-foreground 'face-subtle)
                                         :style nil))
  (set-face-attribute 'custom-button-pressed nil
                      :foreground (face-background 'default)
                      :background (face-foreground 'face-salient)
                      :inherit 'face-salient
                      :box `(:line-width 1
                                         :color ,(face-foreground 'face-salient)
                                         :style nil)
                      :inverse-video nil))
;;; -------------------------------------------------------------------

;; Button function (hardcoded)
;;; -------------------------------------------------------------------
(defun package-make-button (text &rest properties)
  "Insert button labeled TEXT with button PROPERTIES at point.
PROPERTIES are passed to `insert-text-button', for which this
function is a convenience wrapper used by `describe-package-1'."
  (let ((button-text (if (display-graphic-p)
                         text (concat "[" text "]")))
        (button-face (if (display-graphic-p)
                         '(:box `(:line-width 1
                                              :color "#999999":style nil)
                                :foreground "#999999"
                                :background "#F0F0F0")
                       'link)))
    (apply #'insert-text-button button-text
           'face button-face 'follow-link t properties)))
;;; -------------------------------------------------------------------

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(elegant-set-modeline-faces)


(provide 'elegant-theme)
;;; elegant-theme.el ends here
