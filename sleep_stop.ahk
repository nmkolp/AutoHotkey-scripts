; Ctrl + Alt + n stops sleep

#NoEnv
SendMode Input

SleepS(seconds){
    global StopSleep = 0
    Loop %seconds% {
        if StopSleep {
            break
        }
        Sleep, 1000
    }
}

SleepS(60)
; some code after sleep

^!n::StopSleep = 1