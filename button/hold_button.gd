extends Area2D
class_name HoldButton

@onready var sprite: AnimatedSprite2D = $HoldButton

signal activated
signal deactivated

enum ButtonType { HOLD, TOGGLE, PERMANENT }
@export var type: ButtonType = ButtonType.HOLD

var bodies_on_top := 0
var active := false

func _on_body_entered(body):
	if not body.is_in_group("dog") and not body.is_in_group("man"):
		return

	bodies_on_top += 1
	
	match type:
		ButtonType.PERMANENT:
			if not active:
				set_active(true)
				
		ButtonType.TOGGLE:
			set_active(!active)
			
		ButtonType.HOLD:
			if not active:
				set_active(true)

func _on_body_exited(body):
	if not body.is_in_group("dog") and not body.is_in_group("man"):
		return
	
	bodies_on_top -= 1

	# Hanya tipe HOLD yang akan mati saat kaki diangkat
	if type == ButtonType.HOLD:
		if bodies_on_top <= 0:
			bodies_on_top = 0
			if active:
				set_active(false)

func set_active(new_state: bool):
	active = new_state
	if active:
		sprite.frame = 1
		activated.emit()
	else:
		sprite.frame = 0
		deactivated.emit()
