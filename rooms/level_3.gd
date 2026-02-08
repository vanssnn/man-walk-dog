extends Node2D

@onready var switch: Switch = $Switch
@onready var button: HoldButton = $HoldButton
@onready var label: Label = $Label
@onready var door: StaticBody2D = $Door # Script pintumu nempel di sini

func _ready() -> void:
	# 1. Hubungkan Switch untuk perubahan Man -> Flag
	switch.toggled.connect(toggle_action)
	
	# 2. Hubungkan Button untuk buka pintu
	# (Pastikan di Inspector HoldButton, 'Type' sudah diset ke PERMANENT)
	button.activated.connect(_on_button_activated)

func _on_button_activated() -> void:
	# Langsung ubah variabel di script pintu
	door.is_open = true 

func toggle_action(is_action: bool) -> void:
	call_deferred("_apply_toggle", is_action)

func _apply_toggle(is_action: bool) -> void:
	_remove_rope()

	if is_action:
		# --- MODE: FLAG CONTROL (MAN & DOG JADI PATUNG) ---
		label.text = "3. Wait... I am the flag now?"
		_swap_body("ManCB", preload("res://man/man_rb.tscn"), "ManRB")
		_swap_body("Flag", preload("res://flag/flag_cb.tscn"), "FlagCB")
		# Tanpa rope di sini
	else:
		label.text = "2. Man Walk Dog"
		_swap_body("FlagCB", preload("res://flag/flag.tscn"), "Flag")
		_swap_body("ManRB", preload("res://man/man_cb.tscn"), "ManCB")
		
	# Tunggu physics tenang
	await get_tree().physics_frame
	await get_tree().process_frame
	_create_man_dog_rope()

func _create_man_dog_rope() -> void:
	var rope = preload("res://rope/rope.tscn").instantiate()
	rope.name = "Rope"

	# Cari node Manusia (apapun wujudnya: CB atau RB)
	var man_node = get_node_or_null("ManCB")
	if not man_node: man_node = get_node_or_null("ManRB")
	
	# Cari node Anjing (apapun wujudnya: CB atau RB)
	var dog_node = get_node_or_null("DogCB")
	if not dog_node: dog_node = get_node_or_null("DogRB")

	if man_node and dog_node:
		rope.target_a = man_node
		rope.target_b = dog_node
		add_child(rope)

func _swap_body(old_name: String, scene: PackedScene, new_name: String) -> void:
	var old_node = get_node_or_null(old_name)
	if old_node == null: return
	
	var saved_next_scene = ""
	if "next_scene_string" in old_node:
		saved_next_scene = old_node.next_scene_string
		
	var parent := old_node.get_parent()
	var index := old_node.get_index()
	var global_pos = old_node.global_position
	
	old_node.queue_free()
	
	await get_tree().process_frame
	
	var new_node = scene.instantiate()
	new_node.name = new_name
	
	if "next_scene_string" in new_node:
		new_node.next_scene_string = saved_next_scene
		
	parent.add_child(new_node)
	parent.move_child(new_node, index)
	new_node.global_position = global_pos
	
	if new_node is CharacterBody2D:
		new_node.rotation = 0.0
		new_node.scale = Vector2.ONE
		new_node.velocity = Vector2.ZERO
		
	if new_node is CharacterBody2D:
		new_node.rotation = 0.0
		new_node.velocity = Vector2.ZERO

func _remove_rope() -> void:
	var rope = get_node_or_null("Rope")
	if rope: rope.queue_free()

func _create_rope(is_action: bool) -> void:
	var rope = preload("res://rope/rope.tscn").instantiate()
	rope.name = "Rope"
	var target_a = get_node_or_null("ManCB")
	var target_b = get_node_or_null("DogRB")
	if target_a and target_b:
		rope.target_a = target_a
		rope.target_b = target_b
		add_child(rope)
