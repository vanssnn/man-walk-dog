extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		back_to_menu()
		
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		back_to_menu()	

func back_to_menu() -> void:
	SceneManager.change_scene('res://rooms/menu.tscn', { "pattern": "squares" })
