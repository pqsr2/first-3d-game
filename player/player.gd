extends CharacterBody3D

@export var look_sensitivity: int = 200
@export var mouse_sensitivity: float = .5
@export var SPEED: float = 5.5
@export var GRAVITY: float = 20.0
signal vertical_velocity_sample(velocity_y)

var gravity_modifier: float = 1.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func move_camera(direction: Vector2, sensitivity: float):
	rotation_degrees.y -= direction.x * sensitivity
	%Camera3D.rotation_degrees.x -= direction.y * sensitivity
	%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80, 80)
	
func shoot_bullet():
	const BULLET: PackedScene = preload("res://player/bullete_3d.tscn")
	var new_bullet: Area3D = BULLET.instantiate()
	
	%Marker3D.add_child(new_bullet)
	new_bullet.global_transform = %Marker3D.global_transform
	
	%ShootTimer.start()
	

func _unhandled_input(event: InputEvent) -> void:
	# Because it’s event-driven -> best to hold mouse logic here instead of _physics_process
	if event is InputEventMouseMotion:
		move_camera(event.relative, mouse_sensitivity)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	var camera_input_direction_2D: Vector2 = Input.get_vector(
		"look_left", "look_right", "look_up", "look_down"
	)
	move_camera(camera_input_direction_2D, look_sensitivity*delta)
	
	var input_direction_2D: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	var input_direction_3D: Vector3= Vector3(
		input_direction_2D.x, 0.0, input_direction_2D.y
	)
	var direction: Vector3 = transform.basis * input_direction_3D

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	gravity_modifier = 1
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 10.0
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		gravity_modifier = 10.0
		
	velocity.y -= gravity_modifier * GRAVITY * delta
	
	move_and_slide()
	vertical_velocity_sample.emit(velocity.y)
	
	if Input.is_action_pressed("shoot") and %ShootTimer.is_stopped():
		shoot_bullet()


