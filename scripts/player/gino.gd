extends KinematicBody2D
class_name Player

onready var throw_position: Position2D = get_node("ThrowPosition")
onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Texture")

var velocity: Vector2

var previous_animation: String
var current_attack_animation: String

var current_ground_attack: int = 1

var can_anim_move: bool = true
var can_attack: bool = true

export(PackedScene) var dagger_scene

export(bool) var on_hit = false
export(bool) var on_jump = false
export(bool) var on_attack = false

export(int) var jump_speed
export(int) var player_gravity
export(int) var max_fall_speed

export(int) var walk_speed
export(int) var min_walk_threshold

export(float) var friction
export(float) var acceleration

func _physics_process(delta: float) -> void:
	move()
	attack()
	gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	jump()
	animation_manager()
	
	
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
	
	
func attack() -> void:
	if Input.is_action_just_pressed("throw_dagger") and can_attack:
		handle_attack("throw_dagger")
	elif Input.is_action_just_pressed("attack") and is_on_floor():
		handle_attack("ground_attack")
	elif Input.is_action_just_pressed("attack") and not is_on_floor() and can_attack:
		handle_attack("jump_attack")
		
		
func handle_attack(attack_type: String) -> void:
	if attack_type == "ground_attack":
		current_attack_animation = "ground_attack_" + str(current_ground_attack)
		current_ground_attack += 1
		
		if current_ground_attack == 5:
			current_ground_attack = 1
			
	else:
		current_attack_animation = attack_type
		can_attack = false
		
	set_physics_process(false)
	on_attack = true
	
	
func gravity(delta: float) -> void:
	velocity.y += player_gravity * delta
	if velocity.y >= max_fall_speed:
		velocity.y = max_fall_speed
			
			
func jump() -> void:
	if is_on_floor():
		can_attack = true
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		on_jump = true
		yield(get_tree().create_timer(0.1), "timeout")
		velocity.y = -jump_speed
		
		
func throw_dagger() -> void:
	var dagger: Dagger = dagger_scene.instance()
	dagger.direction = sign(throw_position.position.x)
	dagger.global_position = throw_position.global_position
	get_tree().root.call_deferred("add_child", dagger)
	
	
func animation_manager() -> void:
	verify_direction()
	if (velocity.y != 0 or on_jump) and not on_hit and not on_attack:
		jump_animation()
	elif on_attack and not on_hit:
		attack_animation()
	elif not on_hit and not on_attack:
		move_animation()
		
		
func verify_direction() -> void:
	if velocity.x > 0:
		throw_position.position = Vector2(15, 15)
		sprite.flip_h = false
	elif velocity.x < 0:
		throw_position.position = Vector2(-15, 15)
		sprite.flip_h = true
		
		
func jump_animation() -> void:
	can_anim_move = false
	
	if on_jump:
		animation.play("jump_start")
	elif not on_jump:
		animation.play("jump_loop")
		previous_animation = "jump_loop"
		
		
func attack_animation() -> void:
	animation.play(current_attack_animation)
	
	
func move_animation() -> void:
	handle_previous_animation()
	if (abs(velocity.x) > min_walk_threshold) and can_anim_move:
		animation.play("run")
	elif can_anim_move:
		animation.play("idle")
		
		
func handle_previous_animation() -> void:
	match previous_animation:
		"jump_loop":
			animation.play("jump_landing")
			previous_animation = "jump_landing"
			return
				
				
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"jump_start":
			animation.play("jump_loop")
			
		"jump_landing":
			can_anim_move = true
