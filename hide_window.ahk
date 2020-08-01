; Hides specified window
; Ctrl + Alt + s toggles window hide/show
; Ctrl + Alt + e exits script

#NoEnv
SendMode Input

OnExit("ExitF")

ExitF() {
    if NOT WinExist("ahk_exe example.exe") {
        WinShow, ahk_exe example.exe
    }
}

^!s::
    if WinExist("ahk_exe example.exe") {
        WinHide
    } else {
        WinShow, ahk_exe example.exe
    }
    Return

^!e::ExitApp
