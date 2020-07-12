tool
extends Node2D

const Command = preload("res://Command.gd")

signal action_started
signal action_finished
export (String) var action = 'LEFT' setget set_action

export (String, 'KEY_A', 'KEY_W', 'KEY_S', 'KEY_D', 'BUTTON_LEFT', 'BUTTON_RIGHT') var preffered_command = 'KEY_A'

var command: Command setget set_command


func _ready():
	pass # Replace with function body.

func start_action():
	emit_signal('action_started', action)

func finish_action():
	emit_signal('action_finished', action)

func set_command(_command):
	if command:
		command.disconnect('command_activated', self, 'start_action')
		command.disconnect('command_released', self, 'finish_action')
	if _command:
		command = _command
		command.connect('command_activated', self, 'start_action')
		command.connect('command_released', self, 'finish_action')

func set_action(_action):
	action = _action
	$Label.text = action
