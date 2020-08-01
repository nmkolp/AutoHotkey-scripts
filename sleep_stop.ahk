; Ctrl + Alt + n: stops sleep

#NoEnv
SendMode Input

global stopSleep := false

SleepSeconds(seconds) {
    stopSleep := false
    Loop %seconds% {
        if stopSleep {
            break
        }
        Sleep 1000
    }
}

SleepSeconds(60)
; some code after sleep

^!n::stopSleep = true
