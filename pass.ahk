#SingleInstance force

InputString := Object()

SetKeyDelay, 10, 4

hModule := DllCall("LoadLibrary", "str", "dictionary.dll")  
;loads thxe Dictionary.dll file so ahk doesn't free the library after every call and then load it again

Gui, Add, Text,, Please copy-paste the GOLD password below
Gui, Add, Edit, r35 vInputString, Replace this text with the password
Gui, Add, Button, Default, Go
Gui, Add, Button,, Help
Gui, Add, Button,, Config Keys
Gui, Add, Button,, Exit

Gui, Show,, PasswordParser

return

ButtonGo:
{
    GuiControlGet, InputString
    msgbox, Input is now "%InputString%" ;debugging   
    StringSplit, OutputArray, InputString,, %A_Space%`r`n
}

;At this point, OutputArray contains all the letters of InputString but separated. We setup the loop that reads through the array elements and then calls the function in .dll file

ArrayCount = %OutputArray0% ;for some reason, the first element of the "array" counts how many elements are there
IndexCount := 0

msgbox, %ArrayCount%

WinActivate, VisualBoyAdvance, VisualBoyAdvance

CurrCoord := 0

Loop, %ArrayCount%
{
    
    IndexCount += 1  ;ahk-script "arrays" start at 1
    ArrayElement := Asc(OutputArray%IndexCount%) ;chars don't work so have to pass them as ints

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
    result := DllCall("dictionary\testFn", int, 2)
    result2 := DllCall("dictionary\testFn", int, 3)
    result3 := DllCall("dictionary\testFn2", char, "2")
    msgbox, This program helps you put in a GoldenSun password
    Gui, 2:Add, Text,, %result%
    Gui, 2:Add, Text,, %result2%
    Gui, 2:Add, Text,, %result3%    
    Gui, 2:Show,, TEST!*()&*_)(J)
}
return

ButtonExit: 
{
    Gui, Destroy    
}
return

DllCall("FreeLibrary", "UInt", hModule)  