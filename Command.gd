tool
extends Node2D

signal command_activated
signal command_released

const COMMANDS = {
	'KEY_A': [KEY_A, 'A', true],
	'KEY_W': [KEY_W, 'W', true],
	'KEY_S': [KEY_S, 'S', true],
	'KEY_D': [KEY_D, 'D', true],
	'BUTTON_LEFT': [BUTTON_LEFT, 'L_CLK', false],
	'BUTTON_RIGHT': [BUTTON_RIGHT, 'R_CLK', false]
}

export( String,
	'KEY_A', 'KEY_W', 'KEY_S', 'KEY_D',
	'BUTTON_LEFT', 'BUTTON_RIGHT'
) var command_code = 'KEY_A' setget set_command_code

var active = false
var key = COMMANDS[command_code][0]
var command_string = COMMANDS[command_code][1]
var keyboard_type = COMMANDS[command_code][2]

func _ready():
	pass


func _input(event):
	if event is InputEventKey and keyboard_type and event.scancode == key and event.pressed != active:
		active = event.pressed
		if active: emit_signal('command_activated')
		else: emit_signal('command_released')
	
	if event is InputEventMouseButton and !keyboard_type and event.button_index == key and event.pressed != active:
		active = event.pressed
		if active: emit_signal('command_activated')
		else: emit_signal('command_released')


func set_command_code(_command_code):
	command_code = _command_code
	key = COMMANDS[command_code][0]
	command_string = COMMANDS[command_code][1]
	keyboard_type = COMMANDS[command_code][2]
	$Text.text = command_string
