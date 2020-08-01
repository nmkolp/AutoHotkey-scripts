; Autoclicks when holding mouse button
; Ctrl + `: toggles script suspend
; Ctrl + Alt + h: toggles holding mode
;     If enabled, then autoclicks when holding the mouse button
;     If disabled, then keeps autoclicking after the mouse button is released

#NoEnv
SendMode Input

Suspend, On

holdEnabled := true
looping := false

LButton::
    if (looping) {
        return
    }
    looping := true
    loop {
        Click
        Sleep 20
        if (A_IsSuspended OR holdEnabled AND NOT GetKeyState("LButton", "P")) {
            looping := false
            break
        }
    }
    return

RButton::
    if (looping) {
        return
    }
    looping := true
    loop {
        Click, Right
        Sleep 20
        if (A_IsSuspended OR holdEnabled AND NOT GetKeyState("RButton", "P")) {
            looping := false
            break
        }
    }
    return

MButton::
    if (looping) {
        return
    }
    looping := true
    loop {
        Click, Middle
        Sleep 20
        if (A_IsSuspended OR holdEnabled AND NOT GetKeyState("MButton", "P")) {
            looping := false
            break
        }
    }
    return

^`::Suspend

^!h::
    if (holdEnabled) {
        holdEnabled := false
    } else {
        holdEnabled := true
    }
    return
