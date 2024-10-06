extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect button signals to their respective functions
	$VBoxContainer/Button.pressed.connect(_on_play_pressed)
	$VBoxContainer/Button3.pressed.connect(_on_credits_pressed)
	$VBoxContainer/Button4.pressed.connect(_on_quit_pressed)

# Play button pressed
func _on_play_pressed() -> void:
	# Replace "res://scenes/game.tscn" with the path to your game scene
	print("Play button pressed")
	# get_tree().change_scene_to_file("res://scenes/game.tscn")

# Credits button pressed
func _on_credits_pressed() -> void:
	# Replace "res://scenes/credits.tscn" with the path to your credits scene
	print("Credits button pressed")
	# get_tree().change_scene_to_file("res://scenes/credits.tscn")

# Quit button pressed
func _on_quit_pressed() -> void:
	print("Quit button pressed")
	get_tree().quit()
