extends Control

onready var setting_menu = null
onready var btn_start = null
onready var btn_exit = null
onready var main_menu_animation_player: AnimationPlayer = $main_menu_animation_player

func _ready():
	#btn_start.grab_fucus()
	pass


func _on_btn_start_pressed():
	get_tree().change_scene("res://game/scenes/main.tscn")


func _on_btn_settings_pressed():
	pass # Replace with function body.


func _on_btn_exit_pressed():
	get_tree().quit()
