extends Node2D

@onready var damped_spring_joint_2d: DampedSpringJoint2D = $DampedSpringJoint2D
@onready var line_2d: Line2D = $Line2D

@export var target_a: Node2D
@export var target_b: Node2D

var rope_broken: bool = false
@export var max_length: int = 250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damped_spring_joint_2d.position = target_a.position
	damped_spring_joint_2d.look_at(target_b.global_position)
	damped_spring_joint_2d.node_a = target_a.get_path()
	damped_spring_joint_2d.node_b = target_b.get_path()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	line_2d.set_point_position(0, target_a.global_position)
	line_2d.set_point_position(1, target_b.global_position)
	
	var length := target_a.global_position.distance_to(target_b.global_position)
	
	# Trigger only once
	if length > max_length and not rope_broken:
		rope_broken = true
		on_rope_break()
	
# Break logic moved to a function (important)
func on_rope_break() -> void:
	# Optional: disable the joint immediately
	damped_spring_joint_2d.queue_free()
	line_2d.visible = false

	if target_a.has_node("HealthComponent"):
		target_a.get_node("HealthComponent").take_damage()

	if target_a.has_node("PlatformerComponent"):
		target_a.get_node("PlatformerComponent").die()

	if target_b.has_node("PlatformerComponent"):
		target_b.get_node("PlatformerComponent").die()
