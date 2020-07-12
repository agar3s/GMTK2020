extends Node

const Enemy = preload('res://Enemy.tscn')

func _ready():
	randomize()
	$Timer.connect('timeout', self, 'spawn')

func spawn():
	var enemy = Enemy.instance()

	var pos = Vector2(0, -16)
	pos.x = rand_range(0+16, get_viewport().get_visible_rect().size.x - 16)
	enemy.set_position(pos)
	get_tree().root.get_node('Game').add_child(enemy)
	#$TimerKamikaze.wait_time = rand_range(0.5, 1.25)
	
