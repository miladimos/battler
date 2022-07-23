extends Control

onready var btn_start = $VBoxContainer/btn_start
onready var setting_menu = $VBoxContainer/btn_settings
onready var btn_exit = $VBoxContainer/btn_exit
onready var main_menu_animation_player: AnimationPlayer = $main_menu_animation_player

func _ready():
	#btn_start.grab_fucus()
	pass

func _on_btn_start_pressed():
	get_tree().change_scene("res://game/scenes/main.tscn")


func _on_btn_settings_pressed():
	get_tree().change_scene("res://game/scenes/ui/menu/setting/setting_menu.tscn")


func _on_btn_exit_pressed():
	get_tree().quit()
