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
	display_ui.texture = weapon_data["image"]
	
	if weapon_data["name"] == "unarmed":
		weapon_ui.text = weapon_data["name"]
		return
	
	weapon_ui.text = weapon_data["name"] + ": " + weapon_data["ammo"] + "/" + weapon_data["extra_ammo"]


# Show/Hide interaction prompt
func show_interaction_prompt(description = "interact"):
	$interaction.visible = true
	$interaction/description.text = description
	$crosshair.visible = false

func hide_interaction_prompt():
	$interaction.visible = false
	$crosshair.visible = true




