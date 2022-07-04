extends KinematicBody

var speed = 10
var mouse_sensitivity = 0.03
var direction = Vector3()

onready var head = $head

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-80), deg2rad(80))
		
func _process(delta):
	pass
	
func _physics_process(delta):
	direction = Vector3()
	
	if Input.is_action_pressed("player_move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("player_move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("player_move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("player_move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	
	move_and_slide(direction * speed, Vector3.UP)
	
	
	
	
	
	
	
	
	
	
