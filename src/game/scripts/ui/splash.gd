extends Node2D

export(String) var Name
export(String, FILE, "*.gd") var file

func _ready():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://game/scenes/main.tscn")
