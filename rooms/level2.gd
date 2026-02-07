extends Node2D

@onready var switch: Switch = $Switch
@onready var label: Label = $Label

func _ready() -> void:
	switch.toggled.connect(toggle_action)


func _process(delta: float) -> void:
	pass
	
func toggle_action(is_action: bool) -> void:
	if is_action:
		label.text = "2. Dog Walk Man?"
		
		var old_rope = get_node_or_null("Rope")
		var parent = old_rope.get_parent()
		old_rope.queue_free()
		
		swap_body("ManCB", preload("res://man/man_rb.tscn"))
		swap_body("DogRB", preload("res://dog/dog_cb.tscn"))
		
		var new_rope = preload("res://rope/rope.tscn").instantiate()
		new_rope.target_a = get_node("ManRB")
		new_rope.target_b = get_node("DogCB")
		parent.add_child(new_rope)
		
		
		
	else:
		label.text = "2. Man Walk Dog"
		
		var old_rope = get_node_or_null("Rope")
		var parent = old_rope.get_parent()
		old_rope.queue_free()
		
		swap_body("ManRB", preload("res://man/man_cb.tscn"))
		swap_body("DogCB", preload("res://dog/dog_rb.tscn"))
		
		var new_rope = preload("res://rope/rope.tscn").instantiate()
		new_rope.target_a = get_node("ManCB")
		new_rope.target_b = get_node("DogRB")
		parent.add_child(new_rope)

func swap_body(old_name: String, new_scene: PackedScene) -> void:
	var old_node = get_node_or_null(old_name)
	if old_node == null:
		print("ahh")
		return

	var parent = old_node.get_parent()
	var index = old_node.get_index()
	var transform = old_node.global_transform

	old_node.queue_free()

	var new_node = new_scene.instantiate()
	parent.add_child(new_node)
	parent.move_child(new_node, index)
	new_node.global_transform = transform
