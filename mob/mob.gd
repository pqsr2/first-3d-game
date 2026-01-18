extends RigidBody3D

@onready var bat_model = %bat_model
@onready var player: Node = get_node('/root/Game/Player')
@onready var timer: Timer = %Timer

@export var speed: float = randf_range(2, 4)
@export var health: int = 3

func _physics_process(delta: float) -> void:
	var direction: Vector3 = global_position.direction_to(player.global_position)
	direction.y = 0.0
	
	linear_velocity = direction * speed
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI
	
func take_damage():

	if health <= 0:
		return
		
	bat_model.hurt()
	health -= 1
	
	if health <= 0:
		set_physics_process(false)
		gravity_scale = 1.0
		var direction: Vector3 = -1.0 * global_position.direction_to(player.global_position)
		var random_upward_force: Vector3 = Vector3.UP * randf_range(1.0, 5.0)
		
		apply_central_impulse(direction* 10.0 + random_upward_force)
		timer.start()

func _on_timer_timeout() -> void:
	queue_free()
