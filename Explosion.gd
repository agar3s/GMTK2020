extends Sprite

func _ready():
	rotation_degrees = rand_range(0, 360)
	#$Particles2D.emitting = true
	#$flares.emitting = true
	
	#get_tree().root.get_node("Game/Camera2D").call("shake", 8, 1.5)
	
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
