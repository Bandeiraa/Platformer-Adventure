extends Area2D
class_name Dagger

onready var texture: Sprite = get_node("Texture")

var damage: int

var direction: float

export(float) var speed
export(PackedScene) var dagger_explosion

func _ready() -> void:
	update_direction()
	
	
func update_direction() -> void:
	if direction < 0:
		texture.flip_h = true
		
		
func _physics_process(_delta: float) -> void:
	translate(Vector2(direction * speed, 0))
	
	
func on_screen_exited() -> void:
	queue_free()
	
	
func on_body_entered(_body: Object) -> void:
	instance_explosion()
	
	
func instance_explosion() -> void:
	var explosion: AnimatedSprite = dagger_explosion.instance()
	explosion.global_position = global_position
	get_tree().root.call_deferred("add_child", explosion)
	queue_free()
