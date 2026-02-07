extends Node2D
class_name PlatformerComponent

@onready var parent: CharacterBody2D = $".."
@export var is_active: bool = true
@onready var sprite: Sprite2D = null

var gravity_dir: int = 1

enum MovementMode {
	NORMAL_JUMP,
	GRAVITY_FLIP
}
@export var movement_mode: MovementMode = MovementMode.NORMAL_JUMP

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Animation state tracking
var is_jumping: bool = false
var is_walking: bool = false
var walk_tween: Tween = null
var is_dead: bool = false
var was_on_floor: bool = false  # Track previous frame's floor state

func _ready():
	for child in get_parent().get_children():
		if child is Sprite2D:
			sprite = child
			break
			
func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	match movement_mode:
		MovementMode.NORMAL_JUMP:
			normal_jump_mode(delta)
		MovementMode.GRAVITY_FLIP:
			gravity_flip_mode(delta)
	
	# Update animation states
	update_animations()
	
	parent.move_and_slide()

# MOVEMENTS
func horizontal_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		parent.velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		is_walking = true
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, SPEED)
		is_walking = false

func normal_jump_mode(delta: float) -> void:
	parent.up_direction = Vector2.UP
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	
	if is_active:
		if Input.is_action_just_pressed("move_up") and parent.is_on_floor():
			parent.velocity.y = JUMP_VELOCITY
			is_jumping = true
			start_jump_animation()
		horizontal_movement()
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, SPEED)
		is_walking = false
	
func gravity_flip_mode(delta: float) -> void:
	parent.up_direction = Vector2.UP * gravity_dir
	if not parent.is_on_floor():
		parent.velocity.y += parent.get_gravity().y * gravity_dir * delta
	else:
		parent.velocity.y = 0
		
	if is_active and Input.is_action_just_pressed("move_up") and parent.is_on_floor():
		gravity_dir *= -1
		parent.velocity.y = 0
		is_jumping = true
		start_flip_animations()
		start_jump_animation()
		
	horizontal_movement()

# ANIMATION SYSTEM
func update_animations() -> void:
	# Detect actual landing: was in air, now on floor
	if parent.is_on_floor() and not was_on_floor and is_jumping:
		is_jumping = false
		start_land_animation()
	
	# Handle walking animation
	if is_walking and parent.is_on_floor() and not is_jumping:
		if walk_tween == null or not walk_tween.is_running():
			start_walk_animation()
	elif walk_tween != null and walk_tween.is_running():
		stop_walk_animation()
	
	# Update floor state for next frame
	was_on_floor = parent.is_on_floor()

# WALK ANIMATION (Bouncy)
func start_walk_animation() -> void:
	if sprite == null:
		return
	
	if walk_tween != null and walk_tween.is_running():
		walk_tween.kill()
	
	walk_tween = get_tree().create_tween()
	walk_tween.set_loops()
	
	walk_tween.tween_property(sprite, "scale", Vector2(1.1, 0.9), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	walk_tween.parallel().tween_property(sprite, "rotation_degrees", 8, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	walk_tween.tween_property(sprite, "scale", Vector2(0.9, 1.1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	walk_tween.parallel().tween_property(sprite, "rotation_degrees", -8, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	walk_tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	walk_tween.parallel().tween_property(sprite, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func stop_walk_animation() -> void:
	if walk_tween != null and walk_tween.is_running():
		walk_tween.kill()
	
	if sprite != null:
		var reset_tween = get_tree().create_tween()
		reset_tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)
		reset_tween.parallel().tween_property(sprite, "rotation_degrees", 0, 0.1)

# Add these variables at the top with other animation tracking
var jump_tween: Tween = null
var land_tween: Tween = null

func start_jump_animation() -> void:
	if sprite == null:
		return
	
	# Kill existing tweens to prevent conflicts
	if jump_tween != null and jump_tween.is_running():
		jump_tween.kill()
	if land_tween != null and land_tween.is_running():
		land_tween.kill()
	
	jump_tween = get_tree().create_tween()
	jump_tween.set_ease(Tween.EASE_OUT)
	jump_tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.08).set_trans(Tween.TRANS_QUAD)
	jump_tween.tween_property(sprite, "scale", Vector2(0.8, 1.1), 0.3).set_trans(Tween.TRANS_BACK)
	jump_tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK)
	
func start_land_animation() -> void:
	if sprite == null:
		return

	if jump_tween != null and jump_tween.is_running():
		jump_tween.kill()
	if land_tween != null and land_tween.is_running():
		land_tween.kill()
	
	land_tween = get_tree().create_tween()
	land_tween.tween_property(sprite, "scale", Vector2(1.3, 0.7), 0.15).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	land_tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

# GRAVITY FLIP ANIMATION
func start_flip_animations() -> void:
	var target_rotation = 180.0 if gravity_dir == -1 else 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(parent, "rotation_degrees", target_rotation, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

# DEATH ANIMATION (Flicker)
func start_death_animation() -> void:
	if sprite == null or is_dead:
		return
	is_dead = true
	is_active = false
	parent.velocity = Vector2.ZERO
	
	var death_tween = get_tree().create_tween()
	
	for i in range(6):
		death_tween.tween_property(sprite, "modulate:a", 0.0, 0.1)
		death_tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	
	death_tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	death_tween.parallel().tween_property(sprite, "scale", Vector2(0.5, 0.5), 1.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	death_tween.finished.connect(_on_death_animation_finished)

func _on_death_animation_finished() -> void:
	print("Death animation completed!")

# PUBLIC METHOD: Call this from outside to trigger death
func die() -> void:
	start_death_animation()

# PUBLIC METHOD: Respawn/Reset the character
func respawn() -> void:
	is_dead = false
	is_active = true
	is_jumping = false
	is_walking = false
	
	if sprite != null:
		sprite.modulate.a = 1.0
		sprite.scale = Vector2(1.0, 1.0)
	
	parent.velocity = Vector2.ZERO
	gravity_dir = 1
	parent.rotation_degrees = 0
