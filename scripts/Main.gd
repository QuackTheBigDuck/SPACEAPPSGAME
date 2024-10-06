extends Node2D

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	GameState.connect("day_changed", self, "_on_day_changed")
	GameState.connect("mental_health_changed", self, "_on_mental_health_changed")
	GameState.connect("stress_level_changed", self, "_on_stress_level_changed")
	GameState.connect("boss_encounter", self, "_on_boss_encounter")

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func _on_day_changed(new_day):
	$UI/DayLabel.text = "Day: " + str(new_day)

func _on_mental_health_changed(new_value):
	$UI/MentalHealthBar.value = new_value

func _on_stress_level_changed(new_value):
	$UI/StressBar.value = new_value
	
func _on_boss_encounter():
	goto_scene("res://BossBattle.tscn")
