extends Node

const Enemy = preload('res://Enemy.tscn')

func _ready():
	randomize()
	$Timer.connect('timeout', self, 'spawn')

func spawn():
	var enemy = Enemy.instance()

	get_tree().root.get_node('Game').add_child(enemy)
	#$TimerKamikaze.wait_time = rand_range(0.5, 1.25)
	
