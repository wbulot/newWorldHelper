#include "FastFind.au3"
#include <BlockInputEx.au3>

FFSetDebugMode(8)
HotKeySet("{ESC}","Quit") ;Press ESC key to quit

local $isWaiting = 1
local $waitingForCatch = 0
local $hasAFish = 0
local $markerGreen = 0
local $markerOrange = 0

local $repairTimer = TimerInit ()

Local $timerWaitingForCatch = 0
Local $timerHasAFish = 0

Local $aClientSize = WinGetClientSize("[TITLE:New World]")
ConsoleWrite("aClientSize : "&$aClientSize[0]&" "&$aClientSize[1]&@CRLF)
$aClientSize[0] = 1920
$aClientSize[1] = 1080
Local $aClientSizeStartX = 600
Local $aClientSizeStartY = 0
Local $aClientSizeEndX = $aClientSize[0]-600
Local $aClientSizeEndY = $aClientSize[1]

;~ FFSnapShot($aClientSizeStartX,$aClientSizeStartY,$aClientSizeEndX,$aClientSizeEndY,0)
;~ FFSaveBMP("shot", false, 0, 0, 0, 0, 0)
;~ Exit

ConsoleWrite("Start in 5 sec"&@CRLF)
Sleep(5000)

While 1
   If ($isWaiting) Then
	  If (TimerDiff($repairTimer) > 1800000) Then
		 $repairTimer = TimerInit ()
		 ConsoleWrite("Repair ..."&@CRLF)
		 Sleep(2000)
		 Send("{SPACE}")
		 Sleep(2000)
		 Send("{TAB}")
		 Sleep(2000)
		 MouseMove(603, 1028)
		 MouseDown($MOUSE_CLICK_LEFT)
		 Sleep(100)
		 MouseUp($MOUSE_CLICK_LEFT)
		 MouseMove(1102, 664)
		 MouseDown($MOUSE_CLICK_LEFT)
		 Sleep(100)
		 MouseUp($MOUSE_CLICK_LEFT)
		 Sleep(1000)
		 Send("{TAB}")
		 Sleep(2000)
		 Send("{SPACE}")
		 Sleep(2000)
		 Send("{F3}")
;~ 		 START BAIT
		 Sleep(2000)
		 Send("r")
		 Sleep(1000)
		 MouseMove(1184, 457)
		 MouseDown($MOUSE_CLICK_LEFT)
		 Sleep(100)
		 MouseUp($MOUSE_CLICK_LEFT)
		 Sleep(1000)
		 MouseMove(1508, 830)
		 MouseDown($MOUSE_CLICK_LEFT)
		 Sleep(100)
		 MouseUp($MOUSE_CLICK_LEFT)
;~		END BAIT
		 Sleep(3000)
	  EndIf
	  ConsoleWrite("isWaiting"&@CRLF)
	  MouseDown($MOUSE_CLICK_LEFT)
	  Sleep(100);Fishing hold cast time
	  MouseUp($MOUSE_CLICK_LEFT)
	  $isWaiting = 0
	  $waitingForCatch = 1
	  $timerWaitingForCatch = TimerInit ()
	  ConsoleWrite("waitingForCatch"&@CRLF)
   EndIf

   If ($waitingForCatch) Then
	  If (TimerDiff($timerWaitingForCatch) > 35000) Then
		 ConsoleWrite("timerWaitingForCatch, We reset and move the mouse just in case"&@CRLF)
		 Send("{TAB}")
		 Sleep(1000)
		 Send("{TAB}")
		 Sleep(2000)
		 Send("{F3}")
;~ 		 START BAIT
		 Sleep(2000)
		 Send("r")
		 Sleep(1000)
		 MouseMove(1184, 457)
		 MouseDown($MOUSE_CLICK_LEFT)
		 Sleep(100)
		 MouseUp($MOUSE_CLICK_LEFT)
		 Sleep(1000)
		 MouseMove(1508, 830)
		 MouseDown($MOUSE_CLICK_LEFT)
		 Sleep(100)
		 MouseUp($MOUSE_CLICK_LEFT)
;~		END BAIT
		 Sleep(3000)
		 _MouseMovePlus(800,0)
		 $isWaiting = 1
		 $waitingForCatch = 0
	  EndIf
	  FFResetColors()
	  FFAddColor(0x0010503c)
	  FFAddColor(0x00148966)
	  FFAddColor(0x0009E5A5)
	  FFSnapShot($aClientSizeStartX,$aClientSizeStartY,$aClientSizeEndX,$aClientSizeEndY,0)
	  local $searchGreen = FFNearestSpot(10, 10, $aClientSize[0]/2, $aClientSize[1]/2, -1, 5,false,0,0,0,0)
	  If (IsArray($searchGreen)) Then
		 MouseDown($MOUSE_CLICK_LEFT)
		 $waitingForCatch = 0
		 $hasAFish = 1
		 $timerHasAFish = TimerInit()
		 ConsoleWrite("hasAFish"&@CRLF)
		 Sleep(2000)
	  EndIf
   EndIf

   If ($hasAFish) Then
	  ;~ 	  Look for Green marker first to be sure we are fine
	  FFResetColors()
	  FFAddColor(0x000afdb7)
	  FFSnapShot($aClientSizeStartX,$aClientSizeStartY,$aClientSizeEndX,$aClientSizeEndY,0)
	  local $searchGreen = FFNearestSpot(10, 5, $aClientSize[0]/2, $aClientSize[1]/2, -1, 10,false,0,0,0,0)
	  If (IsArray($searchGreen)) Then
		 sleep(10)
	  Else
		 ConsoleWrite("Release line a bit"&@CRLF)
		 ;~ 	  No green marker, we are probably orange, check it and wait a bit
		 FFResetColors()
		 FFAddColor(0x00fe7919)
		 FFAddColor(0x00e6181b)
		 FFSnapShot($aClientSizeStartX,$aClientSizeStartY,$aClientSizeEndX,$aClientSizeEndY,0)
		 local $searchOrange = FFNearestSpot(10, 10, $aClientSize[0]/2, $aClientSize[1]/2, -1, 10,false,0,0,0,0)
		 If (IsArray($searchOrange)) Then
			MouseUp($MOUSE_CLICK_LEFT)
			sleep(1200)
			MouseDown($MOUSE_CLICK_LEFT)
		 Else
			ConsoleWrite("We done ? Wait a fish again."&@CRLF)
			MouseUp($MOUSE_CLICK_LEFT)
			MouseDown($MOUSE_CLICK_LEFT)
			Sleep(100)
			MouseUp($MOUSE_CLICK_LEFT)
			sleep(2000)
			$hasAFish = 0
			$isWaiting = 1
		 EndIf
	  EndIf
	  If (TimerDiff($timerHasAFish) > 180000) Then
		 ConsoleWrite("Looks like we are stuck, cancel this one by right click"&@CRLF)
		 MouseDown($MOUSE_CLICK_RIGHT)
		 Sleep(100)
		 MouseUp($MOUSE_CLICK_RIGHT)
		 $hasAFish = 0
		 $isWaiting = 1
	  EndIf
   EndIf

;~    local $lastPixel = 0
;~    local $countWhite = 0
;~    For $y = 200 To 880 Step +1
;~ 	  For $x = $aClientSizeStartX To $aClientSizeEndX Step +1
;~ 		 local $pixel = FFGetPixel($x,$y,0)
;~ 		 If ($pixel == 16777215 And $lastPixel == 16777215) Then
;~ 			$countWhite = $countWhite+1
;~ 		 Else
;~ 			$countWhite = 0
;~ 		 EndIf
;~ 		 If ($countWhite > 10) Then
;~ 			ConsoleWrite("X:"&$x&"-Y:"&$y&@CRLF)
;~ 		 EndIf
;~ 		 $lastPixel = $pixel
;~ 	  Next
;~    Next

;~    FFSaveBMP("shot", false, 0, 0, 0, 0, 0)
;~    Sleep(100)
Wend

Func Quit()
   Exit
EndFunc

Func _MouseMovePlus($X = "", $Y = "")
   Local $MOUSEEVENTF_MOVE = 0x1
   DllCall("user32.dll", "none", "mouse_event", _
	  "long",  $MOUSEEVENTF_MOVE, _
	  "long",  $X, _
	  "long",  $Y, _
	  "long",  0, _
	  "long",  0)
EndFunc