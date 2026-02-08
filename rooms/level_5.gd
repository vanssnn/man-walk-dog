extends Node2D

@onready var switch: Switch = $Switch
@onready var player = $"ManCB/PlatformerComponent"
@onready var door: StaticBody2D = $Door

func _ready() -> void:
	switch.toggled.connect(toggle_action)
	
func toggle_action(is_action: bool) -> void:
	door.is_open = is_action
	player.movement_mode = PlatformerComponent.MovementMode.GRAVITY_FLIP if is_action else PlatformerComponent.MovementMode.NORMAL_JUMP
