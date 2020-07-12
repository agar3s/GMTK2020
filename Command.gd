tool
extends Node2D

signal command_activated
signal command_released

const COMMANDS = {
	'KEY_A': [KEY_A, 'A', true],
	'KEY_W': [KEY_W, 'W', true],
	'KEY_S': [KEY_S, 'S', true],
	'KEY_D': [KEY_D, 'D', true],
	'BUTTON_LEFT': [BUTTON_LEFT, 'L_CLK', false],
	'BUTTON_RIGHT': [BUTTON_RIGHT, 'R_CLK', false]
}

export( String,
	'KEY_A', 'KEY_W', 'KEY_S', 'KEY_D',
	'BUTTON_LEFT', 'BUTTON_RIGHT'
) var command_code = 'KEY_A' setget set_command_code

var active = false
var draggable = false setget set_draggable
var dragged = false
var drag_offset = 0
var coupled_position

var direction: Vector2 = Vector2(0.0, 0.0) setget set_direction
var drag_force = 1.0
var max_speed = 300
var speed: Vector2 = Vector2(0.0, 0.0)
var target_speed: Vector2 = Vector2(0.0, 0.0)
var colliding_object = null

var coupled = false setget set_coupled

var key = COMMANDS[command_code][0]
var command_string = COMMANDS[command_code][1]
var keyboard_type = COMMANDS[command_code][2]

func _ready():
	connect('mouse_entered', self, 'set_draggable', [true])
	connect('mouse_exited', self, 'set_draggable', [false])
	connect('area_entered', self, 'on_collide')
	connect('area_exited', self, 'on_collides_end')
	add_to_group('command')
	add_to_group('collidable')


func _input(event):
	if event is InputEventKey and keyboard_type and event.scancode == key and event.pressed != active:
		active = event.pressed
		if active: emit_signal('command_activated')
		else: emit_signal('command_released')
	
	if event is InputEventMouseButton and !keyboard_type and event.button_index == key and event.pressed != active:
		active = event.pressed
		if active: emit_signal('command_activated')
		else: emit_signal('command_released')


func set_command_code(_command_code):
	command_code = _command_code
	key = COMMANDS[command_code][0]
	command_string = COMMANDS[command_code][1]
	keyboard_type = COMMANDS[command_code][2]
	$Text.text = command_string

func set_draggable(_draggable):
	draggable = _draggable

func drag(drag_active):
	if dragged and !drag_active and coupled:
		position = coupled_position
	dragged = drag_active and draggable
	if drag_active:
		drag_offset = position - get_global_mouse_position()
	
	if !dragged:
		speed = direction*10
		if speed.length() > max_speed:
			speed = speed.normalized()*max_speed
	
	return dragged

func _process(_delta):
	if dragged:
		direction = get_global_mouse_position() + drag_offset - position
		position = get_global_mouse_position() + drag_offset
	elif !coupled:
		position += speed*_delta
		if position.x + 16 >= get_viewport_rect().size.x and speed.x > 0:
			speed.x *= -1
		elif position.x - 16 <= 0 and speed.x < 0:
			speed.x *= -1
		if position.y + 16 >= get_viewport_rect().size.y and speed.y > 0:
			speed.y *= -1
		elif position.y - 16 <= 0 and speed.y < 0:
			speed.y *= -1

func _physics_process(_delta):
	if colliding_object:
		speed = target_speed
		if speed.length()>max_speed:
			speed = speed.normalized()*max_speed

func set_direction(_direction):
	direction = _direction

func set_coupled(_coupled):
	coupled = _coupled
	if !coupled:
		if active:
			active = false
			emit_signal('command_released')
		if direction.length():
			speed = direction
		else:
			speed.x = randf() - 0.5
			speed.y = randf() - 0.5
		if speed.length() > max_speed:
			speed = speed.normalized()*max_speed
	else:
		speed = Vector2(0.0, 0.0)


func on_collide(area2D):
	var to_bounce = false
	if coupled: return
	
	if area2D.is_in_group('slot'):
		if area2D.command:
			to_bounce = true
		else:
			area2D.setCommand(self)
			return
	if !to_bounce and !area2D.is_in_group('collidable'): return
	
	colliding_object = area2D
	if area2D.is_in_group('collidable'):
		target_speed = area2D.speed
		to_bounce = target_speed.length() == 0
	
	if to_bounce:
		target_speed = speed.bounce(position.direction_to(area2D.position.normalized()).normalized())
		return
	
	if target_speed.x == 0: target_speed.x = speed.x
	if target_speed.y == 0: target_speed.y = speed.y
	
func on_collides_end(area2D):
	if colliding_object and colliding_object == area2D:
		colliding_object = null
		target_speed = Vector2(0.0, 0.0)
	
	
	
	
