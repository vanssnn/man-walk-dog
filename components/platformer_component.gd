extends Node2D
class_name PlatformerComponent

@onready var parent: CharacterBody2D = $".."
@export var is_active: bool = true

enum MovementMode {
	NORMAL_JUMP,
	GRAVITY_FLIP
}
@export var movement_mode: MovementMode = MovementMode.NORMAL_JUMP

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity_dir: int = 1 # 1 for down and -1 for up

func _physics_process(delta: float) -> void:	
	if parent.has_node("HealthComponent"):
		var health := parent.get_node("HealthComponent")
		if health.is_dead:
			is_active = false
		
	
	match movement_mode:
		MovementMode.NORMAL_JUMP:
			normal_jump_mode(delta)
		MovementMode.GRAVITY_FLIP:
			gravity_flip_mode(delta)
	parent.move_and_slide()

func horizontal_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction and is_active:
		parent.velocity.x = direction * SPEED
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, SPEED)	
			
func normal_jump_mode(delta: float) -> void:
	parent.up_direction = Vector2.UP
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	
	if is_active:
		if Input.is_action_just_pressed("move_up") and parent.is_on_floor():
			parent.velocity.y = JUMP_VELOCITY
		horizontal_movement()
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, SPEED)

func flip_gravity():
	gravity_dir *= -1
	parent.velocity.y = 0
	
	var target_rotation = 180.0 if gravity_dir == -1 else 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(parent, "rotation_degrees", target_rotation, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	

func gravity_flip_mode(delta: float) -> void:
	parent.up_direction = Vector2.UP * gravity_dir
	if not parent.is_on_floor():
		parent.velocity.y += parent.get_gravity().y * gravity_dir * delta
	else:
		parent.velocity.y = 0

	if is_active and Input.is_action_just_pressed("move_up") and parent.is_on_floor():
		flip_gravity()
	horizontal_movement()
