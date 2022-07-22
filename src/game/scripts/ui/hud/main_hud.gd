extends Control


func _ready():
	pass

func update_weapon_ui(weapon_data, weapon_slot):
	$background/weapon_ui.text = weapon_data["name"] + ": "
	$background/display/weapon_slot.text = weapon_slot 
	
