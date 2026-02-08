extends Node2D

@onready var switchCharacter: Switch = $SwitchCharacter

@onready var buttonDoor1: HoldButton = $ButtonDoor1
@onready var buttonDoor2: HoldButton = $ButtonDoor2
@onready var buttonDoor4: HoldButton = $ButtonDoor4
@onready var buttonDoor5: HoldButton = $ButtonDoor5

@onready var label: Label = $Label
@onready var door1: StaticBody2D = $Door1
@onready var door2: StaticBody2D = $Door2
@onready var door4: StaticBody2D = $Door4
@onready var door5: StaticBody2D = $Door5

func _ready() -> void:
	# 1. Hubungkan Switch untuk perubahan Man <-> Dog
	switchCharacter.toggled.connect(toggle_action)

	# 2. Hubungkan Button ke Door masing-masing
	# Sinyal 'activated' dikirim saat tombol aktif, 'deactivated' saat tombol mati
	
	# Door 1: Permanent (Sekali aktif, buka terus)
	buttonDoor1.activated.connect(func(): door1.is_open = true)
	
	# Door 2: Toggle (Injak buka, injak lagi tutup)
	# Karena logika Toggle ada di script Button, kita cukup ikuti status active button-nya
	buttonDoor2.activated.connect(func(): door2.is_open = true)
	buttonDoor2.deactivated.connect(func(): door2.is_open = false)
	
	# Door 4: Hold (Injak buka, lepas tutup)
	buttonDoor4.activated.connect(func(): door4.is_open = true)
	buttonDoor4.deactivated.connect(func(): door4.is_open = false)
	
	# Door 5: Toggle (Injak buka, injak lagi tutup)
	buttonDoor5.activated.connect(func(): door5.is_open = true)
	buttonDoor5.deactivated.connect(func(): door5.is_open = false)

# --- LOGIKA SWAP CHARACTER ---

func toggle_action(is_action: bool) -> void:
	call_deferred("_apply_toggle", is_action)

func _apply_toggle(is_action: bool) -> void:
	_remove_rope()

	if is_action:
		# MODE: DOG WALK MAN (Dog is CB, Man is RB)
		label.text = "1. Dog Walk Man"
		_swap_body("ManCB", preload("res://man/man_rb.tscn"), "ManRB")
		_swap_body("DogRB", preload("res://dog/dog_cb.tscn"), "DogCB")
	else:
		# MODE: MAN WALK DOG (Man is CB, Dog is RB)
		label.text = "2. Man Walk Dog"
		_swap_body("DogCB", preload("res://dog/dog_rb.tscn"), "DogRB")
		_swap_body("ManRB", preload("res://man/man_cb.tscn"), "ManCB")
		
	await get_tree().physics_frame
	await get_tree().process_frame
	_create_man_dog_rope()

func _create_man_dog_rope() -> void:
	var rope = preload("res://rope/rope.tscn").instantiate()
	rope.name = "Rope"

	var man_node = get_node_or_null("ManCB")
	if not man_node: man_node = get_node_or_null("ManRB")
	
	var dog_node = get_node_or_null("DogCB")
	if not dog_node: dog_node = get_node_or_null("DogRB")

	if man_node and dog_node:
		rope.target_a = man_node
		rope.target_b = dog_node
		add_child(rope)

# --- FUNGSI SWAP BODY & DATA PERSISTENCE ---

func _swap_body(old_name: String, scene: PackedScene, new_name: String) -> void:
	var old_node = get_node_or_null(old_name)
	if old_node == null: return
	
	# Ambil data next_scene agar tidak hilang saat swap
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
	
	# Kembalikan data next_scene ke node baru
	if "next_scene_string" in new_node:
		new_node.next_scene_string = saved_next_scene
		
	parent.add_child(new_node)
	parent.move_child(new_node, index)
	new_node.global_position = global_pos
	
	if new_node is CharacterBody2D:
		new_node.rotation = 0.0
		new_node.scale = Vector2.ONE
		new_node.velocity = Vector2.ZERO

func _remove_rope() -> void:
	var rope = get_node_or_null("Rope")
	if rope: rope.queue_free()
