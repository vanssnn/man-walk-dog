extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		start_game()
		

func start_game() -> void:
	SceneManager.change_scene('res://rooms/level1.tscn', { "pattern": "scribbles" })
