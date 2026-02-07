extends Area2D



func _on_body_entered(body: Node2D) -> void:
	
	if body.has_node("HealthComponent"):
		var health := body.get_node("HealthComponent")
		health.take_damage()
