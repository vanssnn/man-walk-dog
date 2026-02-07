extends Area2D
class_name Switch

signal toggled(is_on: bool)

@onready var sprite: AnimatedSprite2D = $Switch
@onready var cooldown: Timer = $Timer

@export var cooldown_time := 2

var can_toggle := true
var is_on := false

func _ready():
	cooldown.wait_time = cooldown_time
	cooldown.one_shot = true
	cooldown.timeout.connect(_on_cooldown_timeout)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("dog") and not body.is_in_group("man"):
		return
	if not can_toggle:
		return
	_toggle()

func _toggle():
	can_toggle = false
	is_on = !is_on
	sprite.frame = 1 if is_on else 0
	toggled.emit(is_on)
	cooldown.start()

func _on_cooldown_timeout():
	can_toggle = true
