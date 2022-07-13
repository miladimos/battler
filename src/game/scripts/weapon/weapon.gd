extends Node

class_name Weapon

export var fire_rate = 0.5
export var clip_ammoo_size = 5
export var reload_rate = 1
export var fire_range = 20

var current_ammo = 0
var can_fire = true
var reloading = false
 
onready var raycast = $"/root/MainScene/player/weapon"
onready var ammoo_label = $"/root/MainScene/ui/label"

func _ready():
	current_ammo = clip_ammoo_size
	
func _process(delta):
	
	if reloading:
		ammoo_label.set_text("reloding...")
	else:
		ammoo_label.set_text("%d / %d" %[current_ammo, clip_ammoo_size])
	
	if Input.is_action_just_pressed("player_primary_fire") and can_fire:
		# fire the weapon
		if current_ammo > 0 and not reloading:	
			fire()
		elif not reloading:
			realoding()				
	
	if Input.is_action_just_pressed("player_reloading") and not reloading:
		realoding()
		
func _physics_process(delta):
	pass


func fire():
	print("Fired weapon")
	can_fire = false
	current_ammo -= 1
	#kill_enemy()
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire = true

func realoding():
	print("reloading ...")
	reloading = true
	yield(get_tree().create_timer(reload_rate), "timeout")	
	current_ammo = clip_ammoo_size
	reloading = false
	print("reloading completed ...")	

func kill_enemy():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("enemies"):
			collider.queue_free()
			print("Killed" + collider.name)