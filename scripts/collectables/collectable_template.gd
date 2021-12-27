extends Area2D

onready var animated_sprite: AnimatedSprite = get_node("Texture")

onready var tween: Tween = get_node("Tween")

export(int) var value
export(String) var type
export(Vector2) var offset

func _ready() -> void:
	animated_sprite.play("animation")
	interpolate()
	
	
func interpolate() -> void:
	var _start_interpolation: bool = tween.interpolate_property(
		self,
		"global_position",
		global_position,
		global_position + offset,
		1.5,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	var _end_interpolation: bool = tween.interpolate_property(
		self,
		"global_position",
		global_position + offset,
		global_position,
		1.5,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT,
		1.5
	)
	
	var _start: bool = tween.start()
	
	
func on_body_entered(body: Gino) -> void:
	randomize()
	var random_value: int = randi() % value + 1
	body.stats.update_amount(type, random_value)
	queue_free()
	
	
func on_tween_completed() -> void:
	interpolate()
