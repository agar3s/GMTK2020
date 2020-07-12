tool
extends Node2D

const Command = preload("res://Command.gd")

signal action_started
signal action_finished
export (String) var action = 'LEFT' setget set_action

export (String, 'KEY_A', 'KEY_W', 'KEY_S', 'KEY_D', 'BUTTON_LEFT', 'BUTTON_RIGHT') var preffered_command = 'KEY_A'

var command: Command setget set_command


func _ready():
	connect('area_exited', self, 'check_decoupled')
	connect('area_entered', self, 'check_coupled')
	add_to_group('slot')

func start_action():
	emit_signal('action_started', action)

func finish_action():
	emit_signal('action_finished', action)

func set_command(_command):
	if command:
		if has_node('Direction'):
			command.direction = get_node('Direction').cast_to.normalized()*100
		command.disconnect('command_activated', self, 'start_action')
		command.disconnect('command_released', self, 'finish_action')
		command.disconnect("command_hit", self, 'eject_command')
		command.coupled = false
	command = _command
	if command:
		command.coupled = true
		command.connect('command_activated', self, 'start_action')
		command.connect('command_released', self, 'finish_action')
		command.connect("command_hit", self, 'eject_command')
		command.position = position
		command.coupled_position = position

func set_action(_action):
	action = _action
	$Label.text = action

func check_decoupled(area2d):
	if area2d == command:
		set_command(null)

func check_coupled(area2d):
	if area2d.is_in_group('enemy') and command and command.hp == 0:
		eject_command()
		return
		
	if !(area2d is Command) or command: return
	set_command(area2d)

func eject_command():
	#command.position += get_node('Direction').cast_to*0.5
	set_command(null)

