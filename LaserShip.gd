extends "res://Laser.gd"


func _ready():
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(other):
	if other.is_in_group('enemy'):
		other.armor -= 1
		create_flare()
		get_tree().root.get_node('World/Camera2D').call("shake", 1, 0.13)
		queue_free()
	if other.is_in_group('command'):
		create_flare()
		queue_free()
