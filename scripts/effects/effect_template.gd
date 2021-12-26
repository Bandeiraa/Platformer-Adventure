extends AnimatedSprite

func _ready() -> void:
	play("effect")
	
	
func on_animation_finished() -> void:
	queue_free()
