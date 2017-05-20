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


(define (script-fu-twab img drawable text text2 font:name fontsize fontsizeauto fcolor bcolor transparent)

  (let* (
         (margin-bottom 3)
	 (width (car (gimp-image-width img)))
	 (height (car (gimp-image-height img)))

	 (font:size 
             (if (= fontsizeauto TRUE)
                 (/ height 42) 
                 fontsize))

	 (text2-not-empty (> (string-length text2) 0))
	 (hfactor (if text2-not-empty 2.1 1.0))

	 (bg:width width)
	 (bg:height (* font:size 2.0 hfactor))
	 (bg:x 0)
	 (bg:y (- height bg:height margin-bottom))

	 (text:height font:size)
	 (text:x text:height)

	 (text:y (- height (* text:height 1.5 hfactor) margin-bottom))
	 (text:y2 (- height (* text:height 1.5) margin-bottom))

	 (layer:bg (car (gimp-layer-new img width height RGBA-IMAGE "background-layer" 
					(opacity transparent) 
					NORMAL-MODE)))
	 (layer:text (car (gimp-layer-new img width height RGBA-IMAGE "text-layer" 100 NORMAL-MODE)))
	 )

; add transparent background and text layer
    (gimp-image-add-layer img layer:bg 0)
    (gimp-image-add-layer img layer:text 0)

; add background
    (gimp-rect-select img bg:x bg:y bg:width bg:height REPLACE 0 0)
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
		    SF-STRING "Text 1" ""
		    SF-STRING "Text 2" ""
		    SF-FONT "Font Name" "Sans"
                    SF-ADJUSTMENT "Font Size" '(15 1 1000 1 10 0 1)
		    SF-TOGGLE "Font Size automatisch" TRUE
		    SF-COLOR "Font Color" '(0 0 0)
		    SF-COLOR "Background Color" '(255 255 255)
		    SF-TOGGLE "Transparent" FALSE
		    )
