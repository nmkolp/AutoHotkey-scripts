; Opens specified page in Firefox and saves it
; Ctrl + Alt + e exits script

#NoEnv
SendMode Input

Save(link, filepath)
{
    Send {F6}
    Sleep 500
    SendInput %link%
    Sleep 500
    Send {Enter}
    ; Wait time for page loading
    Sleep 10000
    Send ^s
    Sleep 500
    SendInput %filepath%
    Sleep 500
    Send {Enter}
    Sleep 500
}

Run firefox.exe
Sleep 10000
Send {F6}
Sleep 500

; RunWait mkdir "C:\Users\example\Downloads\NewDirectory"

; link := "https://example.com/"
; filepath := "C:\Users\example\Downloads\NewDirectory\FileName"
; Save(link, filepath)

Sleep 10000
ExitApp

^!e::ExitApp