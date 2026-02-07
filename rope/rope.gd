extends Node2D

@onready var damped_spring_joint_2d: DampedSpringJoint2D = $DampedSpringJoint2D
@onready var line_2d: Line2D = $Line2D

@export var target_a: Node2D
@export var target_b: Node2D

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
