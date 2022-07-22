extends Control


var weapon_ui
var health_ui
var display_ui
var slot_ui


func _enter_tree():
	weapon_ui = $background/weapon_ui
	health_ui = $background/health
	display_ui = $background/display
	slot_ui = $background/display/weapon_slot


func _ready():
	hide_interaction_prompt()


func update_weapon_ui(weapon_data, weapon_slot):
	slot_ui.text = weapon_slot
	display_ui.texture = weapon_data["Image"]
	
	if weapon_data["Name"] == "Unarmed":
		weapon_ui.text = weapon_data["Name"]
		return
	
	weapon_ui.text = weapon_data["Name"] + ": " + weapon_data["Ammo"] + "/" + weapon_data["ExtraAmmo"]


# Show/Hide interaction prompt
func show_interaction_prompt(description = "Interact"):
	$interaction.visible = true
	$interaction/description.text = description
	$crosshair.visible = false

func hide_interaction_prompt():
	$interaction.visible = false
	$crosshair.visible = true




