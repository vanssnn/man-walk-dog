extends Path2D

@export var speed: float = 200.0 
@export var ping_pong: bool = true

@onready var follower: PathFollow2D = $SawFollower
var direction: int = 1

func _process(delta: float) -> void:
	if ping_pong:
		# Logika Bolak-Balik (Ping-pong)
		follower.progress += speed * delta * direction
		
		# Jika sampai ujung atau kembali ke awal, balik arah
		if follower.progress_ratio >= 1.0:
			direction = -1
		elif follower.progress_ratio <= 0.0:
			direction = 1
	else:
		# Logika Looping satu arah
		follower.progress += speed * delta
