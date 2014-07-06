; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


(define (script-fu-twab img drawable text text2 font:name fcolor bcolor transparent)

  (let* (
	 (width (car (gimp-image-width img)))
	 (height (car (gimp-image-height img)))

	 (font:size (/ height 42))

	 (text2-not-empty (> (string-length text2) 0))
	 (hfactor (if text2-not-empty 2.1 1.0))

	 (bg:width width)
	 (bg:height (* font:size 2.0 hfactor))
	 (bg:x 0)
	 (bg:y (- height bg:height))

	 (text:height font:size)
	 (text:x text:height)

	 (text:y (- height (* text:height 1.5 hfactor)))
	 (text:y2 (- height (* text:height 1.5)))

	 (layer:bg (car (gimp-layer-new img width height RGBA-IMAGE "background-layer" 
					(opacity transparent) 
					NORMAL-MODE)))
	 (layer:text (car (gimp-layer-new img width height RGBA-IMAGE "text-layer" 100 NORMAL-MODE)))
	 )

; add transparent background and text layer
    (gimp-image-add-layer img layer:bg 0)
    (gimp-image-add-layer img layer:text 0)

; add background
    (gimp-rect-select img bg:x bg:y bg:width (* bg:height hfactor) REPLACE 0 0)
    (gimp-palette-set-background bcolor)
    (gimp-edit-fill layer:bg BG-IMAGE-FILL)
    (gimp-selection-none img)

; add text
    (gimp-context-set-foreground fcolor)
    (gimp-floating-sel-anchor 
     (car (gimp-text-fontname img layer:text text:x text:y 
			      text 0 TRUE font:size PIXELS font:name)))

; add second text, if not empty
    (if text2-not-empty
	(gimp-floating-sel-anchor 
	 (car (gimp-text-fontname img layer:text text:x text:y2 
				  text2 0 TRUE font:size PIXELS font:name))))

; flatten image (save wouldn't ask to export image)
    (gimp-image-flatten img)

    (gimp-displays-flush)
    ))


(define (opacity transparent)
  (if (= transparent TRUE)
      50 
      100))


(script-fu-register "script-fu-twab"
		    "<Image>/Script-Fu/Text with Background"
		    "Text with Background"
		    "Lars Gregori gimp/at/beidfarbig/de"
		    "Lars Gregori"
		    "2014-06-21"
		    "RGB*"
		    SF-IMAGE "image" 0
		    SF-DRAWABLE "layer" 0
		    SF-STRING "text" ""
		    SF-STRING "text2" ""
		    SF-FONT "font:name" "Sans"
		    SF-COLOR "font:color" '(0 0 0)
		    SF-COLOR "background color" '(255 255 255)
		    SF-TOGGLE "transparent" FALSE
		    )
