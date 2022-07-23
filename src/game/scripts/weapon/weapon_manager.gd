extends Spatial

# NodePath
export(NodePath) var ray_path

# All weapons in the game
var all_weapons = {}

# Carrying Weapons
var weapons = {}

#HUD
var hud

var current_weapon # Reference to the current weapon equipped
var current_weapon_slot: String = "empty" # The current weapon slot

var changing_weapon: bool = false
var unequipped_weapon: bool = false

var weapon_index: int = 0 # For switching weapons through mouse wheel

# examples
#enum {UNIT_NEUTRAL, UNIT_ENEMY, UNIT_ALLY}
#enum Named {THING_1, THING_2, ANOTHER_THING = -1}

func _ready():
	
	hud = get_node("/root/MainScene/main_hud")

	get_node(ray_path).add_exception(owner) # Adds exception of player to the shooting raycast
	
	all_weapons = {
		"unarmed" : preload("res://game/scenes/player/weapon/unarmed/unarmed.tscn"),
		"pistol" : preload("res://game/scenes/player/weapon/pistols/pistol.tscn"),
		"rifle" : preload("res://game/scenes/player/weapon/rifles/rifle.tscn"),
		"sniper" : preload("res://game/scenes/player/weapon/snipers/sniper.tscn"),
		"shotgun" : preload("res://game/scenes/player/weapon/shotguns/shotgun.tscn"),
	}
	
	weapons = {
		"empty" : $unarmed,
		"primary" : $rifle,
		"secondary" : $pistol
	}
	
	# Initialize references for each weapons
	for w in weapons:
		if is_instance_valid(weapons[w]):
			weapon_setup(weapons[w])
	
	# Set current weapon to unarmed
	current_weapon = weapons["empty"]
	change_weapon("empty")
	
	# Disable process
	set_process(false)


# Initializes Weapon's values
func weapon_setup(w):
	w.weapon_manager = self
	w.player = owner
	w.ray = get_node(ray_path)
	w.visible = false


# Process will be called when changing weapons
func _process(delta):
	
	if unequipped_weapon == false:
		if current_weapon.is_unequip_finished() == false:
			return
		
		unequipped_weapon = true
		
		current_weapon = weapons[current_weapon_slot]
		current_weapon.equip()
	
	if current_weapon.is_equip_finished() == false:
		return
	
	changing_weapon = false
	set_process(false)


func change_weapon(new_weapon_slot):
	
	if new_weapon_slot == current_weapon_slot:
		current_weapon.update_ammo() # Refresh
		return
	
	if is_instance_valid(weapons[new_weapon_slot]) == false:
		return
	
	current_weapon_slot = new_weapon_slot
	changing_weapon = true
	
	weapons[current_weapon_slot].update_ammo() # Updates the weapon data on UI, as soon as we change a weapon
	update_weapon_index()
	
	# Change Weapons
	if is_instance_valid(current_weapon):
		unequipped_weapon = false
		current_weapon.unequip()
	
	set_process(true)




# Scroll weapon change
func update_weapon_index():
	match current_weapon_slot:
		"empty":
			weapon_index = 0
		"primary":
			weapon_index = 1
		"secondary":
			weapon_index = 2

func next_weapon():
	weapon_index += 1
	
	if weapon_index >= weapons.size():
		weapon_index = 0
	
	change_weapon(weapons.keys()[weapon_index])

func previous_weapon():
	weapon_index -= 1
	
	if weapon_index < 0:
		weapon_index = weapons.size() - 1
	
	change_weapon(weapons.keys()[weapon_index])





# Firing and Reloading
func fire():
	if not changing_weapon:
		current_weapon.fire()

func fire_stop():
	current_weapon.fire_stop()

func reload():
	if not changing_weapon:
		current_weapon.reload()


# Ammo Pickup
func add_ammo(amount):
	if is_instance_valid(current_weapon) == false || current_weapon.name == "unarmed":
		return false
	
	current_weapon.update_ammo("add", amount)
	return true



# Add weapon to an existing empty slot
func add_weapon(weapon_data):
	
	if not weapon_data["Name"] in all_weapons:
		return
	
	if is_instance_valid(weapons["primary"]) == false:
		
		# Instance the new weapon
		var weapon = Global.instantiate_node(all_weapons[weapon_data["Name"]], Vector3.ZERO, self)
		
		# Initialize the new weapon references
		weapon_setup(weapon)
		weapon.ammo_in_mag = weapon_data["Ammo"]
		weapon.extra_ammo = weapon_data["ExtraAmmo"]
		weapon.mag_size = weapon_data["MagSize"]
		weapon.transform.origin = weapon.equip_pos
		
		# Update the dictionary and change weapon
		weapons["primary"] = weapon
		change_weapon("primary")
		
		return
	
	if is_instance_valid(weapons["secondary"]) == false:
		
		# Instance the new weapon
		var weapon = Global.instantiate_node(all_weapons[weapon_data["Name"]], Vector3.ZERO, self)
		
		# Initialize the new weapon references
		weapon_setup(weapon)
		weapon.ammo_in_mag = weapon_data["Ammo"]
		weapon.extra_ammo = weapon_data["ExtraAmmo"]
		weapon.mag_size = weapon_data["MagSize"]
		weapon.transform.origin = weapon.equip_pos
		
		# Update the dictionary and change weapon
		weapons["secondary"] = weapon
		change_weapon("secondary")
		
		return



# Will be called from player.gd
func drop_weapon():
	if current_weapon_slot != "empty":
		current_weapon.drop_weapon()
		
		# Need to be set to Unarmed in order call change_weapon() function
		current_weapon_slot = "empty"
		current_weapon = weapons["empty"]
		
		# Update HUD
		current_weapon.update_ammo()



# Switch Weapon / Replace Weapon
func switch_weapon(weapon_data):
	
	# Checks whether there's any empty slot available
	# If there is, then we simply add that new weapon to the empty slot
	for i in weapons:
		if is_instance_valid(weapons[i]) == false:
			add_weapon(weapon_data)
			return
	
	
	# If we are unarmed, and pickup a weapon
	# Then the weapon at the primary slot will be dropped and replaced with the new weapon
	if current_weapon.name == "unarmed":
		weapons["primary"].drop_weapon()
		yield(get_tree(), "idle_frame")
		add_weapon(weapon_data)
	
	
	# If the weapon to be picked up and the current weapon are same
	# Theb the ammo of the new weapon is added to the currently equipped weapon
	elif current_weapon.weapon_name == weapon_data["Name"]:
		add_ammo(weapon_data["Ammo"] + weapon_data["ExtraAmmo"])
	
	
	# If we already have an equipped weapon, then we drop it
	# And equip the new weapon
	else:
		drop_weapon()
		
		yield(get_tree(), "idle_frame")
		add_weapon(weapon_data)


# Interaction Prompt
func show_interaction_prompt(weapon_name):
	var desc = "Add Ammo" if current_weapon.weapon_name == weapon_name else "Equip"
	hud.show_interaction_prompt(desc)

func hide_interaction_prompt():
	hud.hide_interaction_prompt()


# Searches for weapon pickups, and based on player input executes further tasks (will be called from player.gd)
func process_weapon_pickup():
	var from = global_transform.origin
	var to = global_transform.origin - global_transform.basis.z.normalized() * 2.0
	var space_state = get_world().direct_space_state
	var collision = space_state.intersect_ray(from, to, [owner], 524288)
	
	if collision:
		var body = collision["collider"]
		
		if body.has_method("get_weapon_pickup_data"):
			var weapon_data = body.get_weapon_pickup_data()
			
			show_interaction_prompt(weapon_data["Name"])
			
			if Input.is_action_just_pressed("interact"):
				switch_weapon(weapon_data)
				body.queue_free()
	else:
		hide_interaction_prompt()



# Update HUD
func update_hud(weapon_data):
	var weapon_slot = "1"
	
	match current_weapon_slot:
		"empty":
			weapon_slot = "1"
		"primary":
			weapon_slot = "2"
		"secondary":
			weapon_slot = "3"
	
	hud.update_weapon_ui(weapon_data, weapon_slot)
