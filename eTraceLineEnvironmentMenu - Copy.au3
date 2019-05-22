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
Global const $activeSettings = "ActiveButtons"
Global const $linksSettings = "ButtonLinks"
Global const $textSettings = "ButtonText"
Global $activeArray
Global $linkArray
Global $testArray


Global $COLOR_CBS_BLUE

;Loading Process
BuildLoading()

;Region selection
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

   Global $MainDate = GUICtrlCreateLabel(_DateTimeFormat(_NowCalc(), 1), 200, 0, 1000, 100, $SS_RIGHT) ;Title label
   GUICtrlSetFont(-1, 24, 800, 0, "Helvetica")
   GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

   Global $COLOR_CBS_BLUE = 0x89D3CC
   GUISetBkColor($COLOR_CBS_BLUE)
EndFunc

Func GetConfigSettings()
   ;Getting the settings from the config file
   $activeArray = IniReadSection($sFilePath, $activeSettings)
   $linkArray = IniReadSection($sFilePath, $linksSettings)
   $testArray = IniReadSection($sFilePath, $textSettings)

   MsgBox(0,"Test array", $activeArray[0][0])
EndFunc
