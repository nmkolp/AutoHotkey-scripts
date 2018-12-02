; Autoclicks when holding mouse button
; Ctrl + ` toggles script suspend

#NoEnv
SendMode Input

Suspend, on

LButton::
  Loop {
    Click
    Sleep 20
    if(GetKeyState("LButton", "P") == 0)
      Break
  }
  Return

RButton::
  Loop {
    Click, Right
    Sleep 20
    if(GetKeyState("RButton", "P") == 0)
      Break
  }
  Return

MButton::
  Loop {
    Click, Middle
    Sleep 20
    if(GetKeyState("MButton", "P") == 0)
      Break
  }
  Return

^`::Suspend