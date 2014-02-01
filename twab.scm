;
;
;	Neuester twab.scm vom 07.11.2007
;
;
;	Hi,
;
;	ich habe das Skript angepasst. Jetzt kannst du die Farbe ausw�hlen und
;	transparenz an/aus-schalten.
;
;	Lars
;
;
;
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

(define (script-fu-twab img drawable text font:name color transparent)

(let* (
       (width (car (gimp-image-width img)))
       (height (car (gimp-image-height img)))

	(font:size (/ height 45))

	(bg:width width)
	(bg:height (* font:size 1.6))
	(bg:x 0)
	(bg:y (- height bg:height))

	(text:x font:size)
	(text:y (- height (* font:size 1.5)))

	(layer:bg (car (gimp-layer-new img width height RGBA-IMAGE "background-layer" 
		(if 
			(= transparent TRUE) 
			50 
			100) 
		NORMAL-MODE)))
	(layer:text (car (gimp-layer-new img width height RGBA-IMAGE "text-layer" 100 NORMAL-MODE)))


)

	(gimp-image-undo-disable img)

	; add transparent background and text layer
	(gimp-image-add-layer img layer:bg 0)
	(gimp-image-add-layer img layer:text 0)
	(gimp-edit-fill layer:bg TRANSPARENT-FILL)
	(gimp-edit-fill layer:text TRANSPARENT-FILL)

	; add background
	(gimp-rect-select img bg:x bg:y bg:width bg:height REPLACE 0 0)
	(gimp-palette-set-background color)
	(gimp-edit-fill layer:bg BG-IMAGE-FILL)
	(gimp-selection-none img)

	; add text
	(gimp-context-set-foreground '(255 255 255))
	(gimp-floating-sel-anchor 
		(car (gimp-text-fontname img layer:text text:x text:y 
			text 0 TRUE font:size PIXELS font:name)))

	; flatten image (save wouldn't ask to export image)
	(gimp-image-flatten img)

	(gimp-image-undo-enable img)

	(gimp-displays-flush)
)
)

(script-fu-register "script-fu-twab"
  "<Image>/Script-Fu/Text with Background"
  "Text with Background"
  "Lars Gregori gimp/at/beidfarbig/de"
  "Lars Gregori"
  "2014-02-01"
  "RGB*"
  SF-IMAGE "image" 0
  SF-DRAWABLE "layer" 0
  SF-STRING "text" ""
  SF-FONT "font:name" "Sans"
  SF-COLOR "color" '(0 0 0)
  SF-TOGGLE "transparent" FALSE
)
