extends Area2D

signal on_hit
const explosion_scene = preload("res://Explosion.tscn")

const laser_scene = preload('res://LaserShip.tscn')

var fire = false setget set_fire
var left = false setget set_left
var right = false setget set_right
var down = false setget set_down
var up = false setget set_up

var hp = 4

var move_x = 0
var move_y = 0

export (float) var speed_max = 250
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
	set_speed()
		
func set_right(on):
	right = on
	set_speed()

func set_down(on):
	down = on
	set_speed()

func set_up(on):
	up = on
	set_speed()

func hit(_damage):
	hp -= 1
	emit_signal('on_hit', hp)
	if hp <= 0:
		create_explosion()
		queue_free()


func set_speed():
	if left and !right:
		move_x = -1
	if !left and right:
		move_x = 1
	if left == right:
		move_x = 0
	if up and !down:
		move_y = -1
	if !up and down:
		move_y = 1
	if up == down:
		move_y = 0
	speed = Vector2(move_x, move_y).normalized()*speed_max


func _process(delta):
	position.x += speed.x*delta
	position.y += speed.y*delta
	
	if position.x < 16:
		speed.x = 0
		position.x = 20
	elif position.x > get_viewport_rect().size.x - 16:
		speed.x = 0
		position.x = get_viewport_rect().size.x - 20
	
	if position.y < 100:
		speed.y = 0
		position.y = 104
	elif position.y > get_viewport_rect().size.y - 32:
		speed.y = 0
		position.y = get_viewport_rect().size.y - 36


func create_explosion():
	var explosion = explosion_scene.instance()
	explosion.set_position(global_position)
	get_tree().root.add_child(explosion)

