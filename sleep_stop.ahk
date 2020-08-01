; Ctrl + Alt + n: stops sleep

#NoEnv
SendMode Input

SleepS(seconds) {
    global StopSleep := false
    Loop, %seconds% {
        if StopSleep {
            Break
        }
        Sleep, 1000
    }
}

SleepS(60)
; some code after sleep

^!n::StopSleep = true
