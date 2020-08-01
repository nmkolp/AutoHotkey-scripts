; Ctrl + Alt + n: stops sleep

#NoEnv
SendMode Input

SleepSeconds(seconds) {
    global stopSleep := false
    Loop, %seconds% {
        if stopSleep {
            Break
        }
        Sleep, 1000
    }
}

SleepSeconds(60)
; some code after sleep

^!n::stopSleep = true
