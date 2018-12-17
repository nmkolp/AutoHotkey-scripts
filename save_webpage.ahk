; Opens specified page in Firefox and saves it
; Ctrl + Alt + e exits script

#NoEnv
SendMode Input

global inputWaitTime := 500

Save(link, filepath)
{
    Send {F6}
    Sleep %inputWaitTime%
    SendInput %link%
    Sleep %inputWaitTime%
    Send {Enter}
    ; Wait time for page loading
    Sleep 10000
    Send ^s
    Sleep %inputWaitTime%
    SendInput %filepath%
    Sleep %inputWaitTime%
    Send {Enter}
    Sleep %inputWaitTime%
}

Run firefox.exe
; Wait time for browser opening
Sleep 10000
Send {F6}
Sleep %inputWaitTime%

; RunWait mkdir "C:\Users\example\Downloads\NewDirectory"

; link := "https://example.com/"
; filepath := "C:\Users\example\Downloads\NewDirectory\FileName"
; Save(link, filepath)

Sleep 10000
ExitApp

^!e::ExitApp