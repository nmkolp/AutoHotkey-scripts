#NoEnv
SendMode Input

CryptGenRandom(min := -2147483648, max := 2147483647, len := 4) {
    n := 0
    if (DllCall("Advapi32.dll\CryptAcquireContext", "Ptr*", hProv, "Ptr", 0, "Ptr", 0, "UInt", 1, "UInt", 0)) {
        VarSetCapacity(Buffer, len, 0)
        if (DllCall("Advapi32.dll\CryptGenRandom", "Ptr", hProv, "UInt", len, "Ptr", &Buffer)) {
            n := Mod(NumGet(Buffer), (max + 1 - min)) + min
        }
        DllCall("Advapi32.dll\CryptReleaseContext", "Ptr", hProv, "UInt", 0)
    }
    return n
}

GeneratePassword(length) {
    pass := ""
    loop %length% {
        pass .= Chr(CryptGenRandom(0x21, 0x7E))
    }
    return pass
}

Gui, Add, Text,, Enter password length:
Gui, Add, Edit, vInputPassLength ym w40
Gui, Add, Button, Default ym, Generate
Gui, Add, Edit, vOutPass xm w224
Gui, Show,, Generate password
return

GuiClose:
    ExitApp

ButtonGenerate:
    GuiControlGet, len,, InputPassLength
    pass := GeneratePassword(len)
    GuiControl, Text, OutPass, %pass%
