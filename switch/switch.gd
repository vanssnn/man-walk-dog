extends Area2D
class_name Switch

signal toggled(is_on: bool)

var is_on := false

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("dog") and not body.is_in_group("man"):
		return
		
	is_on = !is_on
	toggled.emit(is_on)
