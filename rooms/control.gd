extends Control


func _ready():
	modulate.a = 1.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		fade_out()

func fade_out():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	tween.tween_callback(queue_free) # or: hide
