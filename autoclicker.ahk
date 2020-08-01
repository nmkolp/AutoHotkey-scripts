; Autoclicks when holding mouse button
; Ctrl + `: toggles script suspend
; Ctrl + Alt + h: toggles holding mode
;     If enabled, then autoclicks when holding the mouse button
;     If disabled, then keeps autoclicking after the mouse button is released

#NoEnv
SendMode Input

Suspend, on

holdEnabled := true
looping := false

LButton::
  if (looping) {
    Return
  }
  looping := true
  Loop {
    Click
    Sleep 20
    if (A_IsSuspended or holdEnabled and not GetKeyState("LButton", "P")) {
      looping := false
      Break
    }
  }
  Return

RButton::
  if (looping) {
    Return
  }
  looping := true
  Loop {
    Click, Right
    Sleep 20
    if (A_IsSuspended or holdEnabled and not GetKeyState("RButton", "P")) {
      looping := false
      Break
    }
  }
  Return

MButton::
  if (looping) {
    Return
  }
  looping := true
  Loop {
    Click, Middle
    Sleep 20
    if (A_IsSuspended or holdEnabled and not GetKeyState("MButton", "P")) {
      looping := false
      Break
    }
  }
  Return

^`::Suspend

^!h::
  if (holdEnabled) {
    holdEnabled := false
  } else {
    holdEnabled := true
  }
  Return
