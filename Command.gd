extends Node2D

signal command_activated
signal command_released

const COMMANDS = {
	'KEY_A': [KEY_A, 'A'],
	'KEY_W': [KEY_W, 'W'],
	'KEY_S': [KEY_S, 'S'],
	'KEY_D': [KEY_D, 'D'],
}

export(String, 'KEY_A', 'KEY_W', 'KEY_S', 'KEY_D') var command_code = 'KEY_A' setget set_command_code
var active = false
var key = COMMANDS[command_code][0]
var command_string = COMMANDS[command_code][1]

func _ready():
	pass


func _input(event):
	if event is InputEventKey and event.scancode == key and event.pressed != active:
		active = event.pressed
		if active: emit_signal('command_activated')
		else: emit_signal('command_released')


func set_command_code(_command_code):
	command_code = _command_code
	key = COMMANDS[command_code][0]
	command_string = COMMANDS[command_code][1]
