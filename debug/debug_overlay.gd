extends CanvasLayer

var vertical_velocity_buffer: Array[Variant] = []
var max_samples: int = 60
var chart_origin: Vector2 = Vector2(50, 50)
var chart_size: Vector2 = Vector2(100, 100)
var max_velocity: int = 20
var min_velocity: int = -20
var x_step: int = 1

func map_velocity_to_screen(sample: float):
	return remap(sample, min_velocity, max_velocity, chart_origin.y + chart_size.y, chart_origin.y)
	

func draw_chart() -> void:
	var points = []
	for i in vertical_velocity_buffer.size():
		var x = chart_origin.x + i * x_step
		var y = map_velocity_to_screen(vertical_velocity_buffer[i])
		points.push_back(Vector2(x, y))
		
	$JumpVelocityLine.points = points

func _on_character_body_3d_vertical_velocity_sample(velocity_y: Variant) -> void:
	vertical_velocity_buffer.push_back(velocity_y)
	print(velocity_y)
	if vertical_velocity_buffer.size() > max_samples:
		vertical_velocity_buffer.remove_at(0)
	draw_chart()
