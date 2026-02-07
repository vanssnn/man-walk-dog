extends Area2D

@onready var flag: Sprite2D = $Flag
@export var next_scene_string: String

var tween: Tween = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("dog") or body.is_in_group("man"):
		SceneManager.change_scene(next_scene_string, { "pattern": "squares" })

func _ready() -> void:
	if tween != null:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_loops()
	
	var start_y = flag.position.y
	
	tween.tween_property(flag, "position:y", start_y - 2, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(flag, "position:y", start_y + 2, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
