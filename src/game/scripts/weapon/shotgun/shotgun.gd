extends Armed

func _ready():
	#raycast.cast_to  = Vector3(0,0, -fire_rate)
	animation_player = $AnimationPlayer
	animation_player.connect("animation_finished", self, "on_animation_finish")


func on_animation_finish(anim_name):
	.on_animation_finish(anim_name)
