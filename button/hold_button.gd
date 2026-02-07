extends Area2D
class_name HoldButton

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
		activated.emit()

func _on_body_exited(body):
	if not body.is_in_group("dog") and not body.is_in_group("man"):
		return
	bodies_on_top -= 1

	if bodies_on_top <= 0:
		bodies_on_top = 0
		if active:
			active = false
			deactivated.emit()
