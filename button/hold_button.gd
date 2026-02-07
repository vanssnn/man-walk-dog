extends Area2D
class_name HoldButton

@onready var sprite: AnimatedSprite2D = $HoldButton

signal activated
signal deactivated

var bodies_on_top := 0
var active := false

func _on_body_entered(body):
	if not body.is_in_group("dog") and not body.is_in_group("man"):
		return

	bodies_on_top += 1
	if not active:
		active = true
		sprite.frame = 1
		activated.emit()

func _on_body_exited(body):
	if not body.is_in_group("dog") and not body.is_in_group("man"):
		return
	bodies_on_top -= 1

	if bodies_on_top <= 0:
		bodies_on_top = 0
		if active:
			active = false
			sprite.frame = 0
			deactivated.emit()
