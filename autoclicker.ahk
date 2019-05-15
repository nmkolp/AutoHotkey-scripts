; Autoclicks when holding mouse button
; Ctrl + ` toggles script suspend
; Ctrl + Alt + h toggles hold

#NoEnv
SendMode Input

Suspend, on

hold := 1
looping := 0

LButton::
  if (looping) {
    Return
  }
  looping := 1
  Loop {
    Click
    Sleep 20
    if (A_IsSuspended or hold and not GetKeyState("LButton", "P")) {
      looping := 0
      Break
    }
  }
  Return

RButton::
  if (looping) {
    Return
  }
  looping := 1
  Loop {
    Click, Right
    Sleep 20
    if (A_IsSuspended or hold and not GetKeyState("RButton", "P")) {
      looping := 0
      Break
    }
  }
  Return

MButton::
  if (looping) {
    Return
  }
  looping := 1
  Loop {
    Click, Middle
    Sleep 20
    if (A_IsSuspended or hold and not GetKeyState("MButton", "P")) {
      looping := 0
      Break
    }
  }
  Return

^`::Suspend

^!h::
  if (hold) {
    hold := 0
  } else {
    hold := 1
  }
  Return