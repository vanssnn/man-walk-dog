extends Node2D
class_name HealthComponent

const MAX_HEALTH: int = 1
var health: int

var is_dead: bool = false

@export var die_sfx: AudioStream = preload("res://audio/sfx/GameOver.wav")

func _ready() -> void:
	health = MAX_HEALTH

func take_damage():
	#if is_dead: return
	
	health -= 1
	
	if health <= 0:
		is_dead = true
		
		# 1. Play the Game Over SFX
		# We use AudioManager (the Autoload) so it survives the player being disabled
		if die_sfx:
			AudioManager.play_sfx(die_sfx, -5.0) 
		
		reset_level()
		
func reset_level():
	SceneManager.change_scene(get_tree().current_scene.scene_file_path, { "pattern": "squares" })
	
