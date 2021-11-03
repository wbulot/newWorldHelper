#include "FastFind.au3"
#include <BlockInputEx.au3>

FFSetDebugMode(8)

Local $tick = 0
While 1
   Local $timer = TimerInit ()
   $tick = $tick+1

   Local $aClientSize = WinGetClientSize("[TITLE:New World]")
   Local $aClientSizeStartX = $aClientSize[0]/2-20
   Local $aClientSizeStartY = $aClientSize[1]/2-400
   Local $aClientSizeEndX = $aClientSize[0]/2+20
   Local $aClientSizeEndY = $aClientSize[1]/2+0
   FFSnapShot($aClientSizeStartX,$aClientSizeStartY,$aClientSizeEndX,$aClientSizeEndY,0)

   FFAddColor(0x00ff0000)
   FFAddColor(0x00ff3232)
   FFAddColor(0x00cd0000)

   local $searchRed = FFNearestSpot(30, 100, $aClientSize[0]/2, $aClientSize[1]/2, -1, 50,false,0,0,0,0)
   ConsoleWrite(TimerDiff($timer)&@CRLF)
   If (IsArray($searchRed)) Then
	  ConsoleWrite("$searchRed : " & $searchRed[0] & " " & $searchRed[1] & @CRLF)
	  local $pixelTop = FFNearestSpot(1, 1, $searchRed[0], $aClientSizeStartY, -1, 50, false, 0, 0, 0, 0, 0)
	  local $pixelBottom = FFNearestSpot(1, 1, $searchRed[0], $aClientSizeEndY, -1, 50, false, 0, 0, 0, 0, 0)
	  local $diffTopBottom = $pixelBottom[1]-$pixelTop[1]
	  ConsoleWrite("diffTopBottom : "&$diffTopBottom & @CRLF)
	  If ($diffTopBottom > 10) Then
		 ConsoleWrite("$pixelBottom X : "&$pixelBottom[0] & @CRLF)
		 if(Abs($pixelBottom[0] - 960)) < 5 Then
			FFDuplicateSnapShot(0, 1)
			FFKeepColor(-1, 50, false,0,0,0,0,1)
			MouseClick($MOUSE_CLICK_LEFT)
;~ 			FFSaveBMP("shot"&$tick, false, 0, 0, 0, 0, 0)
;~ 			FFSaveBMP("shot"&$tick&"_debug", false, 0, 0, 0, 0, 1)
;~ 			beep(1000,50)
;~ 			Sleep(1000)
		 EndIf
	  EndIf
   EndIf
;~    Exit
Wend