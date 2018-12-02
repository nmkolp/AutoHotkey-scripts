; Block all keyboard keys except for Control and Pause
; Ctrl + Pause toggles script suspend

#NoEnv
SendMode Input

Suspend, on

Nop() {
  Return
}

w := "*"

Loop, 255 {
  ; LButton, RButton, MButton
  ; Control, LControl, RControl
  ; CtrlBreak, Pause
  ; WheelLeft, WheelRight, WheelDown, WheelUp
  If (A_Index == 0x01 OR A_Index == 0x02 OR A_Index == 0x04
  OR A_Index == 0x11 OR A_Index == 0xA2 OR A_Index == 0xA3
  OR A_Index == 0x03 OR A_Index == 0x13
  OR A_Index == 0x9C OR A_Index == 0x9D OR A_Index == 0x9E OR A_Index == 0x9F)
    Continue
  i := % GetKeyName(Format("{1}{2:X}", "vk", A_Index))
  if (i == "")
    Continue
  HotKey, %i%, Nop
  HotKey, %w%%i%, Nop
}

^CtrlBreak::Suspend