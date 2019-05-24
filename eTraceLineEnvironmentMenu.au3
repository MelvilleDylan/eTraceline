#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\Downloads\etraceline_300x153_sCD_icon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <String.au3>
#include <ColorConstants.au3>
#include <Date.au3>
#include <IE.au3>

#comments-start
eTraceLine Menu
Original Author: Alex Wong
Date: 2018-09-25
Comments:
Hung Ly - 2018-09-25
This was originally created by Alex for the TrainingMenuForLaptop function
This was retrofitted to work for menu selection for eTraceLine
Majority of the code and logic is from Alex original Code
#comments-end

;********************************************
;For centering the GUI position
;********************************************
Global $width = @DesktopWidth-100
Global $height = @DesktopHeight-100

;The GUI menus made global so they can be closed in other GUIs


;********************************************
;Global variables for settings arrays
;********************************************
Global const $sFilePath = @ScriptDir & "\eTraceline Settings.ini"
Global const $buttonActiveSection = "ActiveButtons"
Global const $buttonLinkSection = "ButtonLinks"
Global const $buttonTextSection = "ButtonText"

Global $buttonActive
Global $buttonLinks
Global $buttonLabels

;The variables that are passed in the switch statement to open the links
Global $buttonActiveCount ;this is for the size of the arrays
Global $actions
Global $labels

Global $buttonsID[1]


Global $COLOR_CBS_BLUE

;Loading Process
BuildLoading()
GetConfigSettings()
GetRegion()


;Region selection
Func GetRegion()
   ;Create the region
   CreateRegionMenu()

   Local $iIndex

   ;Run the Region GUI
   While 1
	  $nMsg = GUIGetMsg()
	  For $i = 0 to $buttonActiveCount -1
		 if $nMsg = $buttonsID[$i] Then
			Run($buttonLinks[$i][1])
		 EndIf
	  Next
	  If $nMsg = $OptionsExit Then
		 Exit
	  ElseIf $nMsg = $GUI_EVENT_CLOSE Then
		 Exit
	  EndIf
   WEnd

EndFunc


;GUI Funcs
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;Region GUI
Func BuildLoading()
   ;Begins the process with a loading screen
   $LoadingGUI = GUICreate("eTraceLine Menu", $Width-200, $Height-200, @DesktopWidth/2 - ($Width-200)/2, @DesktopHeight/2 - ($Height-200)/2, BitOR($WS_POPUP, $WS_BORDER)) ;Creates the GUI$LoadingGUI = GUICreate("eTraceLine Menu", $Width, $Height, , 100, BitOR($WS_POPUP, $WS_BORDER)) ;Creates the GUI
   GUISetFont(12, 400, 0, "Helvetica")
   GUISetBkColor($COLOR_WHITE)

   ;Get the config settings loaded
   GetConfigSettings()
   Global $Background = GUICtrlCreatePic("C:\eTraceLine\Images\Transparent.jpg", 200, 80, 600, 300)
   $SiteTitle = GUICtrlCreateLabel("Opening eTraceLine Menu", 0, 30, 1000, 100, $SS_CENTER) ;Title label
   GUICtrlSetFont(-1, 50, 800, 0, "Helvetica")
   GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
   GUISetState(@SW_SHOW)

   Sleep(1500)
   GUIDelete($LoadingGUI)
EndFunc

Func SetBackgroundDefault()
   Global $MainTitle = GUICtrlCreateLabel("eTraceLine Menu", 0, 0, 300, 0) ;Title label
   GUICtrlSetFont(-1, 24, 800, 0, "Helvetica")
   GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

   Global $MainDate = GUICtrlCreateLabel(_DateTimeFormat(_NowCalc(), 1), 180, 0, 1000, 100, $SS_RIGHT) ;Title label
   GUICtrlSetFont(-1, 24, 800, 0, "Helvetica")
   GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

   Global $COLOR_CBS_BLUE = 0x89D3CC
   GUISetBkColor($COLOR_CBS_BLUE)
EndFunc

Func GetConfigSettings()
   ;Getting the settings from the config file
   $buttonActive = IniReadSection($sFilePath, $buttonActiveSection)
   $buttonLinks = IniReadSection($sFilePath, $buttonLinkSection)
   $buttonLabels = IniReadSection($sFilePath, $buttonTextSection)
   ;The first entry in the array is number of other array entries, which should be the same for all three arrays
   If not ($buttonActive[0][0] == $buttonLabels[0][0] and $buttonActive[0][0] == $buttonLinks[0][0]) Then
	  MsgBox(0, "Settings Error", "INI file missing information (link, label, and active counts not equal).")
	  Break
   EndIf
EndFunc

Func CreateRegionMenu()
   Local $buttonsCount = $buttonActive[0][0]

   ;The array of buttons
   ReDim $buttonsID[$buttonsCount]

   $RegionMenu = GUICreate("eTraceLine Menu", $Width, $Height, -1, -1, BitOR($WS_POPUP, $WS_BORDER)) ;Creates the GUI
   GUISetFont(24, 800, 0, "Helvetica")

   ;Initial location of the first button
   Local $x = 100
   Local $y = 120

   ;Center of the window
   Local $aClientSize = WinGetClientSize($RegionMenu)
   $buttonWidth = 400
   $buttonHeight = 30
   $TitleWidth = 800

   Global $RegionTitle = GUICtrlCreateLabel("Choose Environment:", ($aClientSize[0] - $TitleWidth)/2, 80,$TitleWidth,40, $SS_CENTER) ;Title label
   GUICtrlSetFont(-1, 30, 1600, 0, "Helvetica")
   GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

   ;Number of buttons that are active
   $buttonActiveCount = 0

   ;Organizing the button settings to be in the same order as $buttonActive
   $buttonLinks = SwapMapEntries($buttonActive, $buttonLinks)
   $buttonLabels = SwapMapEntries($buttonActive, $buttonLabels)

   ;Checking how many active buttons there are
   For $i = 1 to $buttonsCount
	  If ($buttonActive[$i][1] = 1) Then
		 ;Add a button. Have to do -1 because $i refers to $buttonActive, which has the first entry as the number of options
		 $buttonLinks[$buttonActiveCount][1] = $buttonLinks[$i][1]
		 $buttonLabels[$buttonActiveCount][1] = $buttonLabels[$i][1]
		 $buttonLinks[$buttonActiveCount][0] = $buttonLinks[$i][0]
		 $buttonLabels[$buttonActiveCount][0] = $buttonLabels[$i][0]
		 ;Increment Count
		 $buttonActiveCount += 1
	  EndIf
   Next

   ;Adding active buttons
   For $i = 0 to $buttonActiveCount-1
	  $buttonsID[$i] = GUICtrlCreateButton($buttonLabels[$i][1],($aClientSize[0] - $buttonWidth)/2, $y, $buttonWidth,30)
	  GUICtrlSetFont($buttonsID[$i], 15, 800, 0, "Helvetica")
	  ;Increment button position
	  $y += 30
   Next

   ;Adding the exit button
   Global $OptionsExit = GUICtrlCreateButton("Exit", ($aClientSize[0] - $buttonWidth)/2, $y, $buttonWidth, 30) ;Back button
   GUICtrlSetFont($OptionsExit, 14, 800, 0, "Helvetica")

   GUISetState(@SW_SHOW)
   SetBackgroundDefault()
EndFunc

Func SwapMapEntries($properOrderMap, $changingMap)
   ;This is a function for rearranging the order of a 2D array with the inner dimension being a key value pair.
   ;The goal is to organize the $changingMap so that the keys are in the same order as $properOrderMap
   Local $targetMap = $changingMap

   ;We index from 1 because we're working with maps read from IniReadSection, where $map[0][0] is the number of key value pairs
   For $i=1 to UBound($properOrderMap)-1
	  Local $targetKey = $properOrderMap[$i][0]
	  Local $found = False
	  $targetMap[$i][0] = $targetKey
	  For $j=1 to UBound($properOrderMap)-1
		 If ($changingMap[$j][0] == $targetKey) Then
			$targetMap[$i][1] = $changingMap[$j][1]
			$found = True
		 EndIf
	  Next
	  If not $found then
		 MsgBox(0, "Settings Error", "INI file missing information (" & $targetKey & ")")
		 Break
	  EndIf
   Next

   Return $targetMap
EndFunc