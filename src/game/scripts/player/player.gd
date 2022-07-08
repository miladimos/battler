extends KinematicBody

var volecity = Vector3()
var camera_x_rotation = 0

export var speed = 20
export var acceleration = 5
export var jump_power = 30
export var gravity = 0.98
export var mouse_sensitivity = 0.1

onready var head = $head
onready var camera = $head/camera


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta	
			

	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _physics_process(delta):
	var direction = Vector3()
	var head_basis = head.get_global_transform().basis
	
	if Input.is_action_pressed("player_move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("player_move_backward"):
		direction += head_basis.z
	elif Input.is_action_pressed("player_move_right"):
		direction += head_basis.x
	elif Input.is_action_pressed("player_move_left"):
		direction -= head_basis.x
	
	direction = direction.normalized()
	
	volecity = volecity.linear_interpolate(direction * speed, acceleration * delta)
	volecity.y -= gravity
	
	if Input.is_action_just_released("player_jump") and is_on_floor():
		volecity.y += jump_power
		
	volecity = move_and_slide(volecity, Vector3.UP)		
		
