extends Node

var player_mental_health = 100
var player_stress_level = 0
var current_day = 1
var max_days = 30
var days_until_boss = 3

signal day_changed
signal mental_health_changed
signal stress_level_changed
signal boss_encounter

func _ready():
	pass

func new_day():
	current_day += 1
	days_until_boss -= 1
	emit_signal("day_changed", current_day)
	
	if days_until_boss == 0:
		emit_signal("boss_encounter")
		days_until_boss = 3
	elif current_day > max_days:
		end_game()

func update_mental_health(change):
	player_mental_health = clamp(player_mental_health + change, 0, 100)
	emit_signal("mental_health_changed", player_mental_health)

func update_stress_level(change):
	player_stress_level = clamp(player_stress_level + change, 0, 100)
	emit_signal("stress_level_changed", player_stress_level)

func end_game():
	# Implement game over logic here
	print("Game Over! Final mental health: ", player_mental_health)
	print("Final stress level: ", player_stress_level)
	# You might want to show a game over screen or restart the game
