extends Node2D

var daily_actions = ["meditate", "exercise", "communicate", "solve_problem"]
var current_action = null

func _ready():
	for button in $ActionButtons.get_children():
		button.connect("pressed", self, "_on_action_button_pressed", [button.text.to_lower()])

func start_new_day():
	current_action = daily_actions[randi() % daily_actions.size()]
	$ActionDescription.text = "Today's challenge: " + current_action.capitalize()

func _on_action_button_pressed(action):
	resolve_action(action)

func resolve_action(player_choice):
	if player_choice == current_action:
		GameState.update_mental_health(10)
		GameState.update_stress_level(-5)
		$ActionDescription.text = "Great choice! You completed today's challenge."
	else:
		GameState.update_mental_health(-5)
		GameState.update_stress_level(10)
		$ActionDescription.text = "That wasn't the best choice for today's challenge."
	
	get_node("/root/Player").perform_action(player_choice)
	get_node("/root/Player").improve_skill(player_choice)
	
	yield(get_tree().create_timer(2.0), "timeout")
	GameState.new_day()
	if GameState.current_day <= GameState.max_days:
		start_new_day()
	else:
		get_node("/root/Main").goto_scene("res://BossBattle.tscn")
