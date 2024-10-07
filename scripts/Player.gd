extends Node2D

var name = "Astronaut"
var skills = {
	"meditation": 1,
	"exercise": 1,
	"communication": 1,
	"problem_solving": 1
}

func _ready():
	pass

func perform_action(action_name):
	match action_name:
		"meditate":
			GameState.update_mental_health(5 * skills["meditation"])
			GameState.update_stress_level(-3 * skills["meditation"])
		"exercise":
			GameState.update_mental_health(3 * skills["exercise"])
			GameState.update_stress_level(-5 * skills["exercise"])
		"communicate":
			GameState.update_mental_health(4 * skills["communication"])
			GameState.update_stress_level(-2 * skills["communication"])
		"solve_problem":
			GameState.update_mental_health(2 * skills["problem_solving"])
			GameState.update_stress_level(-4 * skills["problem_solving"])

func improve_skill(skill_name):
	if skill_name in skills:
		skills[skill_name] += 1
		print(skill_name + " skill improved to level " + str(skills[skill_name]))
