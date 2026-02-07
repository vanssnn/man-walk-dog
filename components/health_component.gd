extends Node2D
class_name HealthComponent

const MAX_HEALTH: int = 1
var health: int

var is_dead: bool = false

func _ready() -> void:
	health = MAX_HEALTH

func take_damage():
	if is_dead: return
	
	health -= 1
	
	if health <= 0:
		is_dead = true
		#reset_level()
		
#func reset_level():
	#SceneManager.change_scene(get_tree().current_scene.scene_file_path, { "pattern": "squares" })
	
