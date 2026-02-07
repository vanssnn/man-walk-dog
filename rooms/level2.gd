extends Node2D

@onready var switch: Switch = $Switch
@onready var label: Label = $Label

func _ready() -> void:
	switch.toggled.connect(toggle_action)


func toggle_action(is_action: bool) -> void:
	call_deferred("_apply_toggle", is_action)


func _apply_toggle(is_action: bool) -> void:
	_remove_rope()

	# swap bodies
	if is_action:
		label.text = "2. Dog Walk Man?"
		_swap_body("ManCB", preload("res://man/man_rb.tscn"), "ManRB")
		_swap_body("DogRB", preload("res://dog/dog_cb.tscn"), "DogCB")
	else:
		label.text = "2. Man Walk Dog"
		_swap_body("ManRB", preload("res://man/man_cb.tscn"), "ManCB")
		_swap_body("DogCB", preload("res://dog/dog_rb.tscn"), "DogRB")

	# wait until physics + tree are stable
	await get_tree().physics_frame
	await get_tree().process_frame

	_create_rope(is_action)


# Helpers

func _swap_body(old_name: String, scene: PackedScene, new_name: String) -> void:
	var old_node = get_node_or_null(old_name)
	if old_node == null:
		return

	var parent := old_node.get_parent()
	var index := old_node.get_index()
	var global_pos = old_node.global_position

	old_node.queue_free()
	await get_tree().process_frame

	var new_node = scene.instantiate()
	new_node.name = new_name
	parent.add_child(new_node)
	parent.move_child(new_node, index)

	# Preserve position
	new_node.global_position = global_pos

	# Force upright CharacterBody2D
	if new_node is CharacterBody2D:
		new_node.rotation = 0.0
		new_node.scale = Vector2.ONE
		new_node.velocity = Vector2.ZERO


func _remove_rope() -> void:
	var rope = get_node_or_null("Rope")
	if rope:
		rope.queue_free()


func _create_rope(is_action: bool) -> void:
	var rope = preload("res://rope/rope.tscn").instantiate()
	rope.name = "Rope"

	if is_action:
		rope.target_a = $DogCB
		rope.target_b = $ManRB
	else:
		rope.target_a = $ManCB
		rope.target_b = $DogRB

	add_child(rope)
