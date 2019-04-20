; Hides specified window
; Ctrl + Alt + s toggles window hide/show

#NoEnv
SendMode Input

^!s::
    IfWinExist, ahk_exe example.exe
    {
        WinHide
    }
    Else
    {
        WinShow, ahk_exe example.exe
    }
    Return
