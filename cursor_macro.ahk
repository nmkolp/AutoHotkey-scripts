; Ctrl + Alt + r: starts macro recording
; Ctrl + Alt + Shift + r: stops macro recording
; Ctrl + Alt + p: plays macro once
; Ctrl + Alt + Shift + p: plays and loops macro
; Ctrl + Alt + s: stops macro replay
; Mouse Click: records each click, position is not recorded
; Ctrl + Mouse Click: records 10 clicks, position is not recorded
; Ctrl + Shift + Mouse Click: records 100 clicks, position is not recorded
; m / Ctrl + Alt + m: records current mouse position
; w / Ctrl + Alt + w: records waiting for 1 second
; Shift + w / Ctrl + Alt + Shift + w: records waiting for 10 seconds
; Ctrl + Alt + u: deletes last recorded action
; Ctrl + Alt + Shift + u: deletes all recorded actions
; Ctrl + Alt + b: appends all recorded actions in reverse order, excluding first and last actions
; Ctrl + Alt + Shift + b: appends all recorded actions in reverse order, but keeps the order of mouse clicks immediately after mouse move
;     First and last actions are excluded
; Ctrl + Alt + c: toggles mouse clicks block during recording, if enabled then clicks will be recorded but won't be executed
; Ctrl + Alt + k: toggles single key hotkeys (m / w / Shift + w)
;     The keys used in these hotkeys are never blocked regardless of the status of this toggle, only recording is affected
; Ctrl + Alt + d: displays recorded actions
; Ctrl + Alt + e: closes the script

; TODO add saving

#NoEnv
SendMode Input

moves := []
recording := false
playing := false
toBreak := false
resend_clicks := true
simple_hotkeys := true

MOVE := 0
WAIT := 1
RIGHT_CLICK := 2
LEFT_CLICK := 3
MIDDLE_CLICK := 4

^!s::toBreak := true

^!k::
    if simple_hotkeys {
        simple_hotkeys := false
    } else {
        simple_hotkeys := true
    }
    Return

^!c::
    if resend_clicks {
        resend_clicks := false
    } else {
        resend_clicks := true
    }
    Return

~m::
    if (recording AND simple_hotkeys) {
        MouseGetPos, xpos, ypos
        moves.Push(MOVE, xpos, ypos)
    }
    Return

^!m::
    if recording {
        MouseGetPos, xpos, ypos
        moves.Push(MOVE, xpos, ypos)
    }
    Return

AppendAction(Type, Amount) {
    global moves
    global recording
    
    if recording {
        if (moves.Length() >= 3 AND moves[moves.Length() - 2] = Type) {
            moves[moves.Length() - 1] += Amount
        } else {
            moves.Push(Type, Amount, 0)
        }
    }
}

$RButton::
    if (resend_clicks OR NOT recording) {
        Send {RButton Down}
    }
    Return

$RButton UP::
    AppendAction(RIGHT_CLICK, 1)
    if (resend_clicks OR NOT recording) {
        Send {RButton Up}
    }
    Return

$^RButton::
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{RButton Down}
    }
    Return

$^RButton UP::
    AppendAction(RIGHT_CLICK, 10)
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{RButton Up}
    }
    Return

$^+RButton::
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{Shift}{RButton Down}
    }
    Return

$^+RButton UP::
    AppendAction(RIGHT_CLICK, 100)
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{Shift}{RButton Up}
    }
    Return

$LButton::
    if (resend_clicks OR NOT recording) {
        Send {LButton Down}
    }
    Return

$LButton UP::
    AppendAction(LEFT_CLICK, 1)
    if (resend_clicks OR NOT recording) {
        Send {LButton Up}
    }
    Return

$^LButton::
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{LButton Down}
    }
    Return

$^LButton UP::
    AppendAction(LEFT_CLICK, 10)
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{LButton Up}
    }
    Return

$^+LButton::
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{Shift}{LButton Down}
    }
    Return

$^+LButton UP::
    AppendAction(LEFT_CLICK, 100)
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{Shift}{LButton Up}
    }
    Return

$MButton::
    if (resend_clicks OR NOT recording) {
        Send {MButton Down}
    }
    Return

$MButton UP::
    AppendAction(MIDDLE_CLICK, 1)
    if (resend_clicks OR NOT recording) {
        Send {MButton Up}
    }
    Return

$^MButton::
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{MButton Down}
    }
    Return

$^MButton UP::
    AppendAction(MIDDLE_CLICK, 10)
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{MButton Up}
    }
    Return

$^+MButton::
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{Shift}{MButton Down}
    }
    Return

$^+MButton UP::
    AppendAction(MIDDLE_CLICK, 100)
    if (resend_clicks OR NOT recording) {
        Send {Ctrl}{Shift}{MButton Up}
    }
    Return

~w::
    if (recording AND simple_hotkeys) {
        if (moves.Length() >= 3 AND moves[moves.Length() - 2] = WAIT) {
            moves[moves.Length() - 1] += 1000
        } else {
            moves.Push(WAIT, 1000, 0)
        }
    }
    Return

~+w::
    if (recording AND simple_hotkeys) {
        if (moves.Length() >= 3 AND moves[moves.Length() - 2] = WAIT) {
            moves[moves.Length() - 1] += 10000
        } else {
            moves.Push(WAIT, 10000, 0)
        }
    }
    Return

^!w::
    if recording {
        if (moves.Length() >= 3 AND moves[moves.Length() - 2] = WAIT) {
            moves[moves.Length() - 1] += 1000
        } else {
            moves.Push(WAIT, 1000, 0)
        }
    }
    Return

^!+w::
    if recording {
        if (moves.Length() >= 3 AND moves[moves.Length() - 2] = WAIT) {
            moves[moves.Length() - 1] += 10000
        } else {
            moves.Push(WAIT, 10000, 0)
        }
    }
    Return

^!u::
    if (recording AND moves.Length() >= 3) {
        moves.Pop()
        moves.Pop()
        moves.Pop()
    }
    Return

^!+u::
    if recording {
        moves := []
    }
    Return

^!r::
    if NOT playing {
        recording := true
    }
    Return

^!+r::recording := false

^!b::
    if recording {
        i := moves.Length() - 3
        While (i > 3) {
            moves.Push(moves[i - 2], moves[i - 1], moves[i])
            i -= 3
        }
    }
    Return

^!+b::
    if recording {
        swap := false
        i := moves.Length() - 3
        While (i > 3) {
            if (moves[i - 2] > WAIT AND moves[i - 5] = MOVE) {
                swap := true
                i -= 3
                Continue
            }
            moves.Push(moves[i - 2], moves[i - 1], moves[i])
            if swap {
                moves.Push(moves[i + 1], moves[i + 2], moves[i + 3])
                swap := false
            }
            i -= 3
        }
    }
    Return

Play() {
    global moves
    global toBreak
    global MOVE
    global RIGHT_CLICK
    global LEFT_CLICK
    global WAIT
    
    i := 1
    While (i <= moves.Length()) {
        if toBreak {
            Break
        }
        if (moves[i] = MOVE) {
            MouseMove, moves[++i], moves[++i]
            Sleep, 50
        } else if (moves[i] = RIGHT_CLICK) {
            count := moves[++i]
            Loop, %count% {
                if toBreak {
                    Break
                }
                Click, Right
                Sleep, 20
            }
            i++
        } else if (moves[i] = LEFT_CLICK) {
            count := moves[++i]
            Loop, %count% {
                if toBreak {
                    Break
                }
                Click
                Sleep, 20
            }
            i++
        } else if (moves[i] = MIDDLE_CLICK) {
            count := moves[++i]
            Loop, %count% {
                if toBreak {
                    Break
                }
                Click, Middle
                Sleep, 20
            }
            i++
        } else if (moves[i] = WAIT) {
            Sleep, moves[++i]
            i++
        }
        i++
    }
}

^!p::
    if playing {
        Return
    }
    recording := false
    playing := true
    toBreak := false
    Play()
    playing := false
    Return

^!+p::
    if playing {
        Return
    }
    recording := false
    playing := true
    toBreak := false
    Loop {
        Play()
        if toBreak {
            Break
        }
    }
    playing := false
    Return

^!d::
    if playing {
        Return
    }
    message := ""
    i := 1
    While (i <= moves.Length()) {
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
            message .= (i // 3 + 1) . " WAIT " . (moves[++i] // 1000) . " sec" . "`t"
            i++
        }
        i++
    }
    MsgBox, %message%
    Return

^!e::ExitApp
