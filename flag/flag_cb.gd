extends CharacterBody2D

@export var next_scene_string: String

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dog") or body.is_in_group("man"):
		SceneManager.change_scene(next_scene_string, { "pattern": "squares" })
