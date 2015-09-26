#SingleInstance force

InputString := Object()

SetKeyDelay, 10, 4  ;this key delay prevents the script's keystrokes from being passed too fast for the emulator program or the OS to handle; this was configured on Intel Core i5-2410M (2.3GHz) and Windows 7 Home Premium so tweaking might be required

hModule := DllCall("LoadLibrary", "str", "dictionary.dll")  
;loads the Dictionary.dll file so ahk doesn't free the library after every call and then load it again

; this creates the GUI 
Gui, Add, Text,, Please copy-paste the GOLD password below
Gui, Add, Edit, r35 vInputString, Replace this text with the password
Gui, Add, Button, Default, Go
Gui, Add, Button,, Help
Gui, Add, Button,, Exit

Gui, Show,, PasswordParser

return 

;stops sequential execution of code below and makes script wait for button presses

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

WinActivate, VisualBoyAdvance, VisualBoyAdvance

CurrCoord := 0

Loop, %ArrayCount%
{
    
    IndexCount += 1  ;ahk-script "arrays" start at 1
    ArrayElement := Asc(OutputArray%IndexCount%) ;chars don't work in AHK scripts so have to pass them as ints

    FutureCoord := DllCall("dictionary\lookup", int, ArrayElement) ;somehow, with DllCall, you should not enclose variable parametre with % (that usually indicates it's a var and not a literal string)

    x0 := CurrCoord // 100
    x1 := FutureCoord // 100
    y0 := mod(CurrCoord, 100)
    y1 := mod(FutureCoord, 100)

    deltax := x1 - x0
    rowKeys := abs(x1 - x0) 
    if (deltax < 0) {
        Send {Up %rowKeys%}
    }
    else if (deltax = 0) {
    }
    else {
        Send {Down %rowKeys%}        
    }

    deltay := y1 - y0    
    colKeys := abs(y1 - y0)
    if (deltay < 0) {
        Send {Left %colKeys%}
    }
    else if (deltay = 0) {
    }
    else {
        Send {Right %colKeys%}
    }    

    Send {x}

    CurrCoord := FutureCoord 

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
