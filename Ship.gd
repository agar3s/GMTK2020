extends Area2D

var fire = false setget set_fire
var left = false setget set_left
var right = false setget set_right
var down = false setget set_down
var up = false setget set_up

var move_x = 0
var move_y = 0

export (float) var speed = 150

func _ready():
	pass # Replace with function body.


func set_fire(on):
	fire = on

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
	position.x += speed * delta * move_x
	position.x = clamp(position.x, 0 + 16, get_viewport_rect().size.x - 16)
	
	position.y += speed * delta * move_y
	position.y = clamp(position.y, 0 + 100, get_viewport_rect().size.x - 50)
