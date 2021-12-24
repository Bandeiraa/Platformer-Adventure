extends ParallaxBackground
class_name Parallax

onready var layer_clouds: ParallaxLayer = get_node("Layer1")

export(int) var layer_speed

func _physics_process(delta: float) -> void:
	layer_clouds.motion_offset.x -= delta * layer_speed
