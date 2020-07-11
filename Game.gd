extends Node2D

const Slot = preload("res://Slot.gd")

func _ready():
	$Slots/LeftSlot.set_command($Commands/Command_Key_A)
	$Slots/RightSlot.set_command($Commands/Command_Key_D)
	$Slots/UpSlot.set_command($Commands/Command_Key_W)
	$Slots/DownSlot.set_command($Commands/Command_Key_S)
	
	for slot in $Slots.get_children():
		slot.connect('action_started', self, 'handle_action', [true])
		slot.connect('action_finished', self, 'handle_action', [false])
	

func handle_action(action, status):
	print('action ', action, ' ', status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
