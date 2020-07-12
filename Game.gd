tool
extends Node2D

const Slot = preload("res://Slot.gd")

func _ready():
	randomize()
	for slot in $Slots.get_children():
		slot.connect('action_started', self, 'handle_action', [true])
		slot.connect('action_finished', self, 'handle_action', [false])
	
	$Ship.connect('on_hit', self, 'decouple')

func drag(dragging):
	for command in $Commands.get_children():
		if command.drag(dragging): break

func handle_action(action, status):
	match action:
		'LEFT': $Ship.left = status
		'RIGHT': $Ship.right = status
		'UP': $Ship.up = status
		'DOWN': $Ship.down = status
		'FIRE': $Ship.fire = status
		'DRAG': drag(status)
		#'DRAG': decouple()

func decouple():
	var array = range(0, $Slots.get_child_count())
	array.shuffle()
	for index_slot in array:
		var slot = $Slots.get_child(index_slot)
		if slot.command:
			slot.eject_command()
			break
