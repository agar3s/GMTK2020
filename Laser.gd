extends Area2D

export var speed = Vector2(0, -300)
const flare = preload("res://Flare.tscn")

func _ready():
	create_flare()
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")


func _process(delta):
	position += speed*delta


func create_flare():
	var my_flare = flare.instance()
	my_flare.position = position
	get_tree().root.add_child(my_flare)
