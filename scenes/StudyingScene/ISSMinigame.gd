extends Control

var current_question = 0
var score = 0
var questions = [
	{
		"question": "What is the primary function of the ISS?",
		"answers": [
			"Scientific research and experiments in microgravity",
			"Military operations",
			"Space tourism",
			"Deep space exploration",
			"Satellite repair"
		],
		"correct_answer": 0
	},
	{
		"question": "How long do astronauts typically stay on the ISS?",
		"answers": [
			"About 6 months",
			"1 week",
			"1 year",
			"2 years",
			"3 months"
		],
		"correct_answer": 0
	},
	{
		"question": "In which year did the first ISS module launch?",
		"answers": [
			"1998",
			"2000",
			"1995",
			"2001",
			"1990"
		],
		"correct_answer": 0
	}
]

@onready var question_label = $TextureRect2/Label
@onready var answer_labels = []
@onready var timer = $Timer
@onready var score_label = $ScoreLabel
@onready var feedback_label = $FeedbackLabel
@onready var timer_label = $TimerLabel

const DESIGN_WIDTH = 3840.0
const DESIGN_HEIGHT = 2160.0
const BASE_SCALE = 0.5
const QUESTION_TIME = 30

func _ready():
	initialize_answer_labels()
	connect_signals()
	_on_resized()
	load_question()

func initialize_answer_labels():
	for i in range(1, 7):
		var label = get_node_or_null("TextureRect2/Label" + str(i))
		if label:
			answer_labels.append(label)

func connect_signals():
	if get_viewport():
		get_viewport().size_changed.connect(_on_resized)
	
	if timer:
		timer.timeout.connect(_on_timer_timeout)
	else:
		push_error("Timer node not found!")

func _process(delta):
	update_timer_label()

func update_timer_label():
	if timer and timer.time_left > 0 and timer_label:
		timer_label.text = "Time: " + str(ceil(timer.time_left))

func _on_resized():
	if not is_instance_valid(self):
		return
	
	var viewport = get_viewport()
	if not viewport:
		return
	
	var window_size = viewport.get_visible_rect().size
	var scale_factor = min(window_size.x / DESIGN_WIDTH, window_size.y / DESIGN_HEIGHT) * BASE_SCALE
	
	scale_background(window_size, scale_factor)
	scale_questionnaire(window_size, scale_factor)
	scale_character(window_size, scale_factor)
	scale_ui_elements(window_size, scale_factor)
	update_answer_buttons()

func scale_background(window_size, scale_factor):
	var background = get_node_or_null("TextureRect")
	if background:
		background.custom_minimum_size = Vector2(DESIGN_WIDTH, DESIGN_HEIGHT)
		background.scale = Vector2(scale_factor, scale_factor) * 2
		background.position = (window_size - Vector2(DESIGN_WIDTH, DESIGN_HEIGHT) * scale_factor * 2) / 2

func scale_questionnaire(window_size, scale_factor):
	var questionnaire = get_node_or_null("TextureRect2")
	if questionnaire:
		questionnaire.scale = Vector2(scale_factor, scale_factor)
		questionnaire.position = Vector2(window_size.x * 0.6, window_size.y * 0.1)

func scale_character(window_size, scale_factor):
	var character = get_node_or_null("MainCharacter")
	if character:
		character.scale = Vector2(2, 2) * scale_factor * 2
		character.position = Vector2(window_size.x * 0.2, window_size.y * 0.6)

func scale_ui_elements(window_size, scale_factor):
	if score_label:
		scale_and_position_label(score_label, Vector2(window_size.x * 0.05, window_size.y * 0.05), scale_factor)
	if timer_label:
		scale_and_position_label(timer_label, Vector2(window_size.x * 0.05, window_size.y * 0.1), scale_factor)
	if feedback_label:
		scale_and_position_label(feedback_label, Vector2(window_size.x * 0.5, window_size.y * 0.8), scale_factor)

func scale_and_position_label(label: Label, position: Vector2, scale_factor: float):
	if label:
		label.scale = Vector2(scale_factor, scale_factor) * 1.5
		label.position = position

func update_answer_buttons():
	for i in range(answer_labels.size()):
		var label = answer_labels[i]
		if label:
			var existing_button = label.get_node_or_null("Button")
			if existing_button:
				existing_button.queue_free()
			
			var button = Button.new()
			button.flat = true
			button.size = label.size
			button.position = Vector2.ZERO
			button.name = "Button"
			button.connect("pressed", _on_answer_selected.bind(i))
			label.add_child(button)

func load_question():
	if current_question >= questions.size():
		end_game()
		return
	
	var q = questions[current_question]
	if question_label:
		question_label.text = q["question"]
		question_label.visible_characters = -1  # Show all characters
		question_label.visible_ratio = 1.0      # Show full text
	
	for i in range(min(q["answers"].size(), answer_labels.size())):
		if i < answer_labels.size() and answer_labels[i]:
			answer_labels[i].text = q["answers"][i]
	
	if feedback_label:
		feedback_label.text = ""
	
	if timer:
		timer.start(QUESTION_TIME)
	
	queue_redraw()

func _on_answer_selected(answer_index):
	if timer:
		timer.stop()
	
	if answer_index == questions[current_question]["correct_answer"]:
		score += 1
		update_score_label()
		show_feedback("Correct!", Color.GREEN)
	else:
		show_incorrect_feedback()
	
	await get_tree().create_timer(2.0).timeout
	current_question += 1
	load_question()

func update_score_label():
	if score_label:
		score_label.text = "Score: " + str(score)

func show_feedback(text: String, color: Color):
	if feedback_label:
		feedback_label.text = text
		feedback_label.modulate = color

func show_incorrect_feedback():
	if feedback_label:
		feedback_label.text = "Incorrect. The correct answer was: " + \
							  questions[current_question]["answers"][questions[current_question]["correct_answer"]]
		feedback_label.modulate = Color.RED

func _on_timer_timeout():
	show_feedback("Time's up!", Color.YELLOW)
	await get_tree().create_timer(2.0).timeout
	current_question += 1
	load_question()

func end_game():
	if question_label:
		question_label.text = "Game Over!"
	
	for label in answer_labels:
		if label:
			label.text = ""
	
	if feedback_label:
		feedback_label.text = "Final Score: " + str(score) + "/" + str(questions.size())
		feedback_label.modulate = Color.WHITE
	
	if timer_label:
		timer_label.text = ""
