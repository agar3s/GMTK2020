extends Sprite

func _ready():
	$AnimationPlayer.play("fade_out")
	$AnimationPlayer.connect("animation_finished", self, "destroy_me")

func destroy_me(one):
	queue_free()
