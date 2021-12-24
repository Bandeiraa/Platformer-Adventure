extends KinematicBody2D
class_name Player

var velocity: Vector2

export(int) var jump_speed
export(int) var player_gravity
export(int) var max_fall_speed

export(int) var walk_speed

export(float) var friction
export(float) var acceleration

func _physics_process(delta: float) -> void:
	move()
	gravity(delta)
	velocity = move_and_slide(velocity)
	
	
func move() -> void:
	if get_horizontal_movement() != 0:
		velocity.x = lerp(velocity.x, get_horizontal_movement() * walk_speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		
		
func get_horizontal_movement() -> float:
	return (
		Input.get_action_strength("right") - 
		Input.get_action_strength("left")
	)
	
	
func gravity(delta: float) -> void:
	velocity.y += player_gravity * delta
	if velocity.y >= max_fall_speed:
		velocity.y = max_fall_speed
