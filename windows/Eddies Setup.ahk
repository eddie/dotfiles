#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

GroupAdd, Terminal, ahk_class VirtualConsoleClass
GroupAdd, Terminal, ahk_class Vim
GroupAdd, Terminal, ahk_class PuTTY


InTerminal() {
	return WinActive("ahk_group Terminal")
}

; --------------------------------------------------------------
; media/function keys all mapped to the right option key
; --------------------------------------------------------------
F7::SendInput {Media_Prev}
F8::SendInput {Media_Play_Pause}
F9::SendInput {Media_Next}
F10::SendInput {Volume_Mute}
F11::SendInput {Volume_Down}
F12::SendInput {Volume_Up}
; F3 (expose key) = Widnows 10 expose
F3::Send {LWin down}{Tab}{LWin up}

; open Windows start with shortcut for Finder
LCtrl & Space::Send {RCtrl up}{LWin}

; F13-15, standard windows mapping
F13::SendInput {PrintScreen}
F14::SendInput {ScrollLock}
F15::SendInput {Pause}

<#q::Send !{F4}


; minimize windows
#m::WinMinimize,a
<^e::Send {End}

; *nux Home/End
CtrlA() {
	If InTerminal()
	{
		Send ^a
	} else {
		Send {Home}
	}
}
<^a::CtrlA()
