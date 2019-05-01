; Hides specified window
; Ctrl + Alt + s toggles window hide/show
; Ctrl + Alt + e exits script

#NoEnv
SendMode Input

OnExit("ExitF")

ExitF()
{
    if not WinExist("ahk_exe example.exe") {
        WinShow, ahk_exe example.exe
    }
}

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

^!e::ExitApp
