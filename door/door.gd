extends StaticBody2D

@export var is_open := false

@export var speed := 0.5

func _ready() -> void:
	scale.x = 0.0 if is_open else 1.0

func _process(delta: float) -> void:
	var target := 0.0 if is_open else 1.0
	scale.x = move_toward(scale.x, target, speed * delta)
