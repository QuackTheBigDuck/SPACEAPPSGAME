extends Node2D

var boss_health = 100
var boss_name = ""
var boss_attacks = []
var current_turn = "player"
var cosmic_events = [
	{
		"name": "Solar Flare",
		"attacks": ["radiation burst", "electromagnetic pulse", "communication disruption"],
		"description": "A sudden eruption of intense energy from the Sun's surface."
	},
	{
		"name": "Meteor Shower",
		"attacks": ["debris impact", "navigation interference", "resource depletion"],
		"description": "A celestial event where many meteors appear to originate from one point in the night sky."
	},
	{
		"name": "Gravitational Anomaly",
		"attacks": ["spatial distortion", "time dilation", "equipment malfunction"],
		"description": "A localized variation in the gravitational field, potentially caused by unseen massive objects."
	}
]

func _ready():
	randomize()
	select_cosmic_event()
	$UI/BossHealthBar.value = boss_health
	$UI/BattleLog.text = "A cosmic event '" + boss_name + "' has occurred!"
	for button in $UI/ActionButtons.get_children():
		button.connect("pressed", self, "_on_action_button_pressed", [button.text])

func select_cosmic_event():
	var event = cosmic_events[randi() % cosmic_events.size()]
	boss_name = event["name"]
	boss_attacks = event["attacks"]

func start_battle():
	current_turn = "player"
	$UI/BattleLog.text += "\nYour turn! Choose an action."

func _on_action_button_pressed(action):
	if current_turn == "player":
		player_action(action)
		yield(get_tree().create_timer(1.0), "timeout")
		if !check_battle_end():
			current_turn = "boss"
			boss_attack()

func boss_attack():
	var attack = boss_attacks[randi() % boss_attacks.size()]
	$UI/BattleLog.text += "\n" + boss_name + " uses " + attack + "!"
	GameState.update_mental_health(-10)
	GameState.update_stress_level(5)
	yield(get_tree().create_timer(1.0), "timeout")
	if !check_battle_end():
		current_turn = "player"
		$UI/BattleLog.text += "\nYour turn! Choose an action."

func player_action(action):
	$UI/BattleLog.text += "\nYou use " + action + "!"
	boss_health -= 20
	$UI/BossHealthBar.value = boss_health
	GameState.update_mental_health(5)
	GameState.update_stress_level(-3)

func check_battle_end():
	if boss_health <= 0:
		end_battle(true)
		return true
	elif GameState.player_mental_health <= 0:
		end_battle(false)
		return true
	return false

func end_battle(player_won):
	if player_won:
		$UI/BattleLog.text += "\nCongratulations! You've overcome the " + boss_name + "!"
		yield(get_tree().create_timer(2.0), "timeout")
		show_learning_bubble()
	else:
		$UI/BattleLog.text += "\nThe " + boss_name + " has overwhelmed you. Don't give up!"
		yield(get_tree().create_timer(2.0), "timeout")
		get_node("/root/Main").goto_scene("res://GameOverScene.tscn")

func show_learning_bubble():
	var event_info = cosmic_events.find(func(event): return event["name"] == boss_name)
	var description = event_info["description"]
	
	var bubble = preload("res://LearningBubble.tscn").instance()
	bubble.set_text(boss_name, description)
	add_child(bubble)
	
	yield(bubble, "closed")
	get_node("/root/Main").goto_scene("res://DailyAction.tscn")
