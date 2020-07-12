extends Area2D

export var speed = Vector2(0, 200)
export var armor = 2 setget set_armor

const explosion_scene = preload('res://Explosion.tscn')

func _ready():
	connect('area_entered', self, '_on_hit')
	add_to_group('enemy')
	add_to_group('collidable')


func _process(delta):
	position += delta*speed
	
	if position.y - 16 > get_viewport_rect().size.y:
		queue_free()

func set_armor(value):
	armor = value
	if armor <= 0:
		explode()
		#var Score = get_tree().root.get_node("World/HUD/Score")
		#Score.score += 5
		queue_free()

func explode():
	var explosion = explosion_scene.instance()
	explosion.set_position(global_position)
	get_tree().root.add_child(explosion)


func _on_hit(other):
	if other.is_in_group('ship'):
		other.hit()
		explode()
		queue_free()
