extends Area2D

signal on_hit

const laser_scene = preload('res://LaserShip.tscn')

var fire = false setget set_fire
var left = false setget set_left
var right = false setget set_right
var down = false setget set_down
var up = false setget set_up


var move_x = 0
var move_y = 0

export (float) var speed_max = 150
var speed: Vector2 = Vector2(0.0, 0.0)

func _ready():
	$Timer.connect('timeout', self, 'shoot')
	add_to_group('collidable')
	add_to_group('ship')

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
	set_speed()
		
func set_right(on):
	right = on 
	if right:
		move_x += 1
	else:
		move_x -= 1
	set_speed()

func set_down(on):
	down = on
	if down:
		move_y += 1
	else:
		move_y -= 1
	set_speed()

func set_up(on):
	up = on
	if up:
		move_y -= 1
	else:
		move_y += 1
	set_speed()

func hit():
	emit_signal('on_hit')


func set_speed():
	move_x = clamp(move_x, -1.0, 1.0)
	move_y = clamp(move_y, -1.0, 1.0)
	speed = Vector2(move_x, move_y).normalized()*speed_max


func _process(delta):
	position.x += speed.x*delta
	position.y += speed.y*delta
	
	if position.x < 16:
		speed.x = 0
		position.x = 16
	elif position.x > get_viewport_rect().size.x - 16:
		speed.x = 0
		position.x = get_viewport_rect().size.x - 16
	
	if position.y < 100:
		speed.y = 0
		position.y = 100
	elif position.y > get_viewport_rect().size.y - 32:
		speed.y = 0
		position.y = get_viewport_rect().size.y - 32



