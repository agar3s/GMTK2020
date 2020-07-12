tool
extends Node2D

const Slot = preload("res://Slot.gd")

func _ready():
	randomize()
	for slot in $Slots.get_children():
		slot.connect('action_started', self, 'handle_action', [true])
		slot.connect('action_finished', self, 'handle_action', [false])

func drag(dragging):
	for command in $Commands.get_children():
		if command.drag(dragging): break

func handle_action(action, status):
	print('action ', action, ' ', status)
	match action:
		'LEFT': $Ship.left = status
		'RIGHT': $Ship.right = status
		'UP': $Ship.up = status
		'DOWN': $Ship.down = status
		'FIRE': $Ship.fire = status
		'DRAG': drag(status)

