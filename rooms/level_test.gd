extends Node2D

@onready var button1 = $"HoldButton"
@onready var button2 = $"HoldButton2"

func action1() -> void:
	print("This is action 1")
func stop1() -> void:
	print("This stopp")

func action2() -> void:
	print("This is action 2")
	
func _ready() -> void:
	button1.activated.connect(action1)
	button2.activated.connect(action2)
	button1.deactivated.connect(stop1)
