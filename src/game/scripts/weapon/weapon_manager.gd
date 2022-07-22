extends Node

# All weapons in the game
var all_weapons = {}

# Carrying weapon
var weapons = {}

# hud
var hud

var current_weapon
var current_weapon_slot = "Empty"

var changing_weapon = false
var unequipped_weapon = false



func _ready():
	hud = owner.get_node("main_hud")
	
	all_weapons = {
		"unarmed" : preload("res://game/scenes/player/weapon/unarmed/unarmed.tscn"),
		"grenade" : preload("res://game/scenes/player/weapon/grenades/grenade.tscn"),
		"pistol" : preload("res://game/scenes/player/weapon/pistols/pistol.tscn"),
		"shotgun" : preload("res://game/scenes/player/weapon/shotguns/shotgun.tscn"),
		"sniper" : preload("res://game/scenes/player/weapon/snipers/sniper.tscn"),
	}







