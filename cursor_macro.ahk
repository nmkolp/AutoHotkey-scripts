; Ctrl + Alt + r: starts macro recording
; Ctrl + Alt + Shift + r: stops macro recording
; Ctrl + Alt + p: plays macro once
; Ctrl + Alt + Shift + p: plays and loops macro
; Ctrl + Alt + s: stops macro replay
; Mouse Click: records each click, position is not recorded
; Ctrl + Mouse Click: records 10 clicks, position is not recorded
; Ctrl + Shift + Mouse Click: records 100 clicks, position is not recorded
; m / Ctrl + Alt + m: records current cursor position
; w / Ctrl + Alt + w: records a pause for 1 second
; Shift + w / Ctrl + Alt + Shift + w: records a pause for 10 seconds
; Ctrl + Alt + u: deletes last recorded action
; Ctrl + Alt + Shift + u: deletes all recorded actions
; Ctrl + Alt + b: appends all recorded actions in reverse order, excluding first and last actions
; Ctrl + Alt + Shift + b: appends all recorded actions in reverse order, but keeps the order of the mouse clicks that directly follow a cursor move; first and last actions are excluded
; Ctrl + Alt + c: toggles mouse clicks block during recording; if enabled, then clicks will be recorded but won't be executed
; Ctrl + Alt + k: toggles single key hotkeys (m / w / Shift + w); if disabled, then no actions will be recorded when these hotkeys are pressed
;     The keys used in these hotkeys are never blocked regardless of the state of this parameter, only recording is affected
; Ctrl + Alt + d: displays recorded actions
; Ctrl + Alt + e: closes the script

; TODO add saving

#NoEnv
SendMode Input

global moves := []
global recording := false
global playing := false
global toBreak := false
global resendClicks := true
global simpleHotkeysEnabled := true

global MOVE := 0
global WAIT := 1
global RIGHT_CLICK := 2
global LEFT_CLICK := 3
global MIDDLE_CLICK := 4

^!s::toBreak := true

^!k::
    if (simpleHotkeysEnabled) {
        simpleHotkeysEnabled := false
    } else {
        simpleHotkeysEnabled := true
    }
    return

^!c::
    if (resendClicks) {
        resendClicks := false
    } else {
        resendClicks := true
    }
    return

~m::
    if (recording AND simpleHotkeysEnabled) {
        MouseGetPos, xpos, ypos
        moves.Push(MOVE, xpos, ypos)
    }
    return

^!m::
    if (recording) {
        MouseGetPos, xpos, ypos
        moves.Push(MOVE, xpos, ypos)
    }
    return

AppendAction(type, amount) {
    if (recording) {
        if (moves.Length() >= 3 AND moves[moves.Length() - 2] = type) {
            moves[moves.Length() - 1] += amount
        } else {
            moves.Push(type, amount, 0)
        }
    }
}

$RButton::
    if (resendClicks OR NOT recording) {
        Send {RButton Down}
    }
    return

$RButton UP::
    AppendAction(RIGHT_CLICK, 1)
    if (resendClicks OR NOT recording) {
        Send {RButton Up}
    }
    return

$^RButton::
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{RButton Down}
    }
    return

$^RButton UP::
    AppendAction(RIGHT_CLICK, 10)
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{RButton Up}
    }
    return

$^+RButton::
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{Shift}{RButton Down}
    }
    return

$^+RButton UP::
    AppendAction(RIGHT_CLICK, 100)
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{Shift}{RButton Up}
    }
    return

$LButton::
    if (resendClicks OR NOT recording) {
        Send {LButton Down}
    }
    return

$LButton UP::
    AppendAction(LEFT_CLICK, 1)
    if (resendClicks OR NOT recording) {
        Send {LButton Up}
    }
    return

$^LButton::
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{LButton Down}
    }
    return

$^LButton UP::
    AppendAction(LEFT_CLICK, 10)
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{LButton Up}
    }
    return

$^+LButton::
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{Shift}{LButton Down}
    }
    return

$^+LButton UP::
    AppendAction(LEFT_CLICK, 100)
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{Shift}{LButton Up}
    }
    return

$MButton::
    if (resendClicks OR NOT recording) {
        Send {MButton Down}
    }
    return

$MButton UP::
    AppendAction(MIDDLE_CLICK, 1)
    if (resendClicks OR NOT recording) {
        Send {MButton Up}
    }
    return

$^MButton::
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{MButton Down}
    }
    return

$^MButton UP::
    AppendAction(MIDDLE_CLICK, 10)
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{MButton Up}
    }
    return

$^+MButton::
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{Shift}{MButton Down}
    }
    return

$^+MButton UP::
    AppendAction(MIDDLE_CLICK, 100)
    if (resendClicks OR NOT recording) {
        Send {Ctrl}{Shift}{MButton Up}
    }
    return

~w::
    if (simpleHotkeysEnabled) {
        AppendAction(WAIT, 1)
    }
    return

~+w::
    if (simpleHotkeysEnabled) {
        AppendAction(WAIT, 10)
    }
    return

^!w::AppendAction(WAIT, 1)

^!+w::AppendAction(WAIT, 10)

^!u::
    if (recording AND moves.Length() >= 3) {
        moves.Pop()
        moves.Pop()
        moves.Pop()
    }
    return

^!+u::
    if (recording) {
        moves := []
    }
    return

^!r::
    if (NOT playing) {
        recording := true
    }
    return

^!+r::recording := false

^!b::
    if (recording) {
        i := moves.Length() - 3
        while (i > 3) {
            moves.Push(moves[i - 2], moves[i - 1], moves[i])
            i -= 3
        }
    }
    return

^!+b::
    if (recording) {
        swap := false
        i := moves.Length() - 3
        while (i > 3) {
            if (moves[i - 2] > WAIT AND moves[i - 5] = MOVE) {
                swap := true
                i -= 3
                continue
            }
            moves.Push(moves[i - 2], moves[i - 1], moves[i])
            if (swap) {
                moves.Push(moves[i + 1], moves[i + 2], moves[i + 3])
                swap := false
            }
            i -= 3
        }
    }
    return

Play() {
    i := 1
    while (i <= moves.Length()) {
        if (toBreak) {
            break
        }
        if (moves[i] = MOVE) {
            MouseMove, moves[++i], moves[++i]
            Sleep 50
        } else if (moves[i] = RIGHT_CLICK) {
            count := moves[++i]
            loop %count% {
                if (toBreak) {
                    break
                }
                Click, Right
                Sleep 20
            }
            i++
        } else if (moves[i] = LEFT_CLICK) {
            count := moves[++i]
            loop %count% {
                if (toBreak) {
                    break
                }
                Click
                Sleep 20
            }
            i++
        } else if (moves[i] = MIDDLE_CLICK) {
            count := moves[++i]
            loop %count% {
                if (toBreak) {
                    break
                }
                Click, Middle
                Sleep 20
            }
            i++
        } else if (moves[i] = WAIT) {
            seconds := moves[++i]
            loop %seconds% {
                if (toBreak) {
                    break
                }
                Sleep 1000
            }
            i++
        }
        i++
    }
}

^!p::
    if (playing) {
        return
    }
    recording := false
    playing := true
    toBreak := false
    Play()
    playing := false
    return

^!+p::
    if (playing) {
        return
    }
    recording := false
    playing := true
    toBreak := false
    loop {
        Play()
        if (toBreak) {
            break
        }
    }
    playing := false
    return

^!d::
    if (playing) {
        return
    }
    message := ""
    i := 1
    while (i <= moves.Length()) {
        if (moves[i] = MOVE) {
            message .= (i // 3 + 1) . " MOVE x" . moves[++i] . " y" . moves[++i] . "`t"
        } else if (moves[i] = RIGHT_CLICK) {
            message .= (i // 3 + 1) . " RIGHT CLICK x" . moves[++i] . "`t"
            i++
        } else if (moves[i] = LEFT_CLICK) {
            message .= (i // 3 + 1) . " LEFT CLICK x" . moves[++i] . "`t"
            i++
        } else if (moves[i] = MIDDLE_CLICK) {
            message .= (i // 3 + 1) . " MIDDLE CLICK x" . moves[++i] . "`t"
            i++
        } else if (moves[i] = WAIT) {
            message .= (i // 3 + 1) . " WAIT " . moves[++i] . " sec" . "`t"
            i++
        }
        i++
    }
    MsgBox %message%
    return

^!e::ExitApp
