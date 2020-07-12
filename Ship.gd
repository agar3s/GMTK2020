extends Area2D

const laser_scene = preload('res://LaserShip.tscn')

var fire = false setget set_fire
var left = false setget set_left
var right = false setget set_right
var down = false setget set_down
var up = false setget set_up


var move_x = 0
var move_y = 0

export (float) var speed = 150

func _ready():
	$Timer.connect('timeout', self, 'shoot')

func shoot():
	create_laser($Cannons/Center.global_position)

func create_laser(pos):
	var laser = laser_scene.instance()
	laser.set_position(pos)
	get_tree().root.add_child(laser)

func set_fire(on):
	fire = on
	if fire:
		shoot()
		$Timer.start()
	else:
		$Timer.stop()

func set_left(on):
	left = on
	if left:
		move_x -= 1
	else:
		move_x += 1
		
func set_right(on):
	right = on 
	if right:
		move_x += 1
	else:
		move_x -= 1

func set_down(on):
	down = on
	if down:
		move_y += 1
	else:
		move_y -= 1

func set_up(on):
	up = on
	if up:
		move_y -= 1
	else:
		move_y += 1


func _process(delta):
	var delta_move = Vector2(move_x, move_y).normalized()*speed*delta
	position.x += delta_move.x
	position.y += delta_move.y
	
	position.x = clamp(position.x, 0 + 16, get_viewport_rect().size.x - 16)
	position.y = clamp(position.y, 0 + 100, get_viewport_rect().size.x - 50)
