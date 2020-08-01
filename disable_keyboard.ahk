; Block all keyboard keys except for Control and Pause
; Ctrl + Pause: toggles script suspend

#NoEnv
SendMode Input

Suspend, On

Nop() {
    Return
}

w := "*"

Loop, 511 {
    if (A_Index == 0x000 ; MouseKeys
        OR A_Index == 0x01D OR A_Index == 0x11D ; LControl, RControl
        OR A_Index == 0x146 OR A_Index == 0x045) { ; CtrlBreak, Pause
        Continue
    }
    i := % Format("{1}{2:X}", "SC", A_Index)
    HotKey, %i%, Nop
    HotKey, %w%%i%, Nop
}

^CtrlBreak::Suspend
