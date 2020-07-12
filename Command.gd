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
var draggable = false setget set_draggable
var dragged = false
var drag_offset = 0
var coupled_position

var coupled = false setget set_coupled

var key = COMMANDS[command_code][0]
var command_string = COMMANDS[command_code][1]
var keyboard_type = COMMANDS[command_code][2]

func _ready():
	connect("mouse_entered", self, 'set_draggable', [true])
	connect("mouse_exited", self, 'set_draggable', [false])


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

func set_draggable(_draggable):
	draggable = _draggable

func drag(drag_active):
	if dragged and !drag_active and coupled:
		position = coupled_position
	dragged = drag_active and draggable
	if drag_active:
		drag_offset = position - get_global_mouse_position()
	
	return dragged

func _process(_delta):
	if dragged:
		position = get_global_mouse_position() + drag_offset


func set_coupled(_coupled):
	coupled = _coupled
