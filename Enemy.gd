extends Area2D

export var speed = Vector2(0, 100)
export var armor = 1 setget set_armor
export var damage = 25

const explosion_scene = preload('res://Explosion.tscn')

func _ready():
	connect('area_entered', self, '_on_hit')
	add_to_group('enemy')
	add_to_group('collidable')
	position.y = -16
	position.x = rand_range(0+16, get_viewport().get_visible_rect().size.x - 16)
	var direction = 1 if (get_viewport().get_visible_rect().size.x/2 - position.x) > 0 else -1
	speed.y += randi()%100
	speed.x += randf()*50*direction


func _process(delta):
	position += delta*speed
	
	if position.y - 16 > get_viewport_rect().size.y:
		queue_free()


func set_armor(value):
	armor = value
	if armor <= 0:
		explode()
		var Score = get_tree().root.get_node("Game/HUD/Score")
		Score.score += 5
		queue_free()


func explode():
	var explosion = explosion_scene.instance()
	explosion.set_position(global_position)
	get_tree().root.add_child(explosion)


func _on_hit(other):
	if other.is_in_group('ship') or other.is_in_group('command'):
		other.hit(damage)
		explode()
		queue_free()


