#NoEnv
SendMode Input

CryptGenRandom(Min := -2147483648, Max := 2147483647, Len := 4) {
    Local n

    If (DllCall("Advapi32.dll\CryptAcquireContext", "Ptr*", hProv, "Ptr", 0, "Ptr", 0, "UInt", 1, "UInt", 0)) {
        VarSetCapacity(Buffer, Len, 0)
        If (DllCall("Advapi32.dll\CryptGenRandom", "Ptr", hProv, "UInt", Len, "Ptr", &Buffer)) {
            n := Mod(NumGet(Buffer), (Max + 1 - Min)) + Min
        }

        DllCall("Advapi32.dll\CryptReleaseContext", "Ptr", hProv, "UInt", 0)
    }

    return n
}

GeneratePassword(length) {
    Local pass := ""

    Loop %length% {
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