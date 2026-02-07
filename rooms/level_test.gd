extends Node2D

@onready var button1 = $"HoldButton"
@onready var button2 = $"HoldButton2"
@onready var switch = $"Switch"

func action1() -> void:
	print("This is action 1")
func stop1() -> void:
	print("This stopp")

func action2() -> void:
	print("This is action 2")
	
func toggleAction(isAction: bool) -> void:
	print(isAction)
	
func _ready() -> void:
	button1.activated.connect(action1)
	button2.activated.connect(action2)
	button1.deactivated.connect(stop1)
	switch.toggled.connect(toggleAction)
