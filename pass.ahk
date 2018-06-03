; this directive basically "reloads" the script if another one is running
#SingleInstance force

delay := 40
hold_length = %delay%
SetKeyDelay, %delay%, %hold_length%
;this key delay prevents the script's keystrokes from being sent too fast for the emulator program to handle; this was configured on Intel Core i7-8550U Windows 10 so tweaking might be required

hModule := DllCall("LoadLibrary", "str", "dictionary.dll")
;explicitly loads the Dictionary.dll file so ahk doesn't free the library after every call and then load it again

InputString := Object() ;container to hold input text

; GUI initialization
Gui, Add, Text,, Please copy-paste the GOLD password below
Gui, Add, Edit, r35 vInputString, Replace this text with the password
Gui, Add, Button, Default, Go
Gui, Add, Button,, Help
Gui, Add, Button,, Exit

Gui, Show,, PasswordParser

return ;stops sequential execution of code below and makes script wait for button presses

ButtonGo:
{
    GuiControlGet, InputString
    ;msgbox, Input is now "%InputString%" ;debugging
    StringSplit, OutputArray, InputString,, %A_Space%`r`n
}

;At this point, OutputArray contains all the letters of InputString but separated. We setup the loop that reads through the array elements and then calls the function in .dll file

ArrayCount = %OutputArray0% ;for some reason, the first element of the "array" counts how many elements are there
IndexCount := 0

;msgbox, %ArrayCount%  ;debugging: shows # of password chars

if (WinExist("VisualBoyAdvance")) {
    WinActivate
    ;Sleep %delay% * 2
}
else {
    msgbox, can't detect VisualBoyAdvance
    Gui, Destroy
}

CurrCoord := 0

Loop, %ArrayCount%
{

    IndexCount += 1  ;ahk-script "arrays" start at 1
    ArrayElement := Asc(OutputArray%IndexCount%) ;chars don't work in AHK scripts so have to pass them as ints
    FutureCoord := DllCall("Gs2Pass\lookup", int, ArrayElement) ;somehow, with DllCall, you should not enclose variable parametre with % (that usually indicates it's a var and not a literal string)

    ;msgbox, FutureCoord = %FutureCoord%

    x0 := CurrCoord // 100
    x1 := FutureCoord // 100
    y0 := mod(CurrCoord, 100)
    y1 := mod(FutureCoord, 100)

    deltax := x1 - x0
    ;msgbox, deltax = %deltax%
    rowKeys := abs(deltax)
    ;msgbox, rowKeys = %rowKeys%
    if (deltax < 0) {
        Send {Up %rowKeys%}
    }
    else if (deltax = 0) {
    }
    else {
        Send {Down %rowKeys%}
    }

    ;Sleep %delay%

    deltay := y1 - y0
    ;msgbox, deltay = %deltay%
    colKeys := abs(deltay)
    ;msgbox, colKeys = %colKeys%
    if (deltay < 0) {
        Send {Left %colKeys%}
    }
    else if (deltay = 0) {
    }
    else {
        Send {Right %colKeys%}
    }

    ;Sleep %delay%

    Send, x

    CurrCoord := FutureCoord
    ;Sleep %delay%
}
return

ButtonHelp:
{
    msgbox, This program helps you put in the gold version of the GoldenSun 2 password; please have your VisualBoyAdvance emulator open and "GoldenSun 2: the Lost Age" ROM loaded and at the password input screen. For now, inputs are hardcoded to arrow keys for direction and keyboard 'X' for GBA's 'A' button
}
return

ButtonExit:
{
    Gui, Destroy
}
return

DllCall("FreeLibrary", "UInt", hModule)

