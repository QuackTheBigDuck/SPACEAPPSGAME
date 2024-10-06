extends Control

# Variables to track player stats
var energy: float = 5.0
var strength: float = 5.0
var happiness: float = 5.0
var hunger: float = 5.0

# Decrease rates per second
const ENERGY_DECREASE_RATE = 0.05
const HUNGER_DECREASE_RATE = 0.025
const HAPPINESS_DECREASE_RATE = 0.01
const STRENGTH_DECREASE_RATE = 0.01

# References to UI elements
@onready var energy_bar = $Energy_Bar
@onready var strength_bar = $Strength_Bar
@onready var happiness_bar = $Happiness_Bar
@onready var hunger_bar = $Hunger_Bar

func _ready():
	# Check if all progress bars are found
	if not energy_bar:
		print("Energy_Bar not found")
	if not strength_bar:
		print("Strength_Bar not found")
	if not happiness_bar:
		print("Happiness_Bar not found")
	if not hunger_bar:
		print("Hunger_Bar not found")

	# Connect button signals
	var buttons = [
		["Button_Spacewalks", _on_spacewalk],
		["Button_Zero-Gravity", _on_zero_gravity],
		["Button_Research and Discovery", _on_research],
		["Button_Mining and Resource Gathering", _on_mining],
		["Button_Eat", _on_eat],
		["Button_Rest", _on_rest],
		["Button_Stargazing", _on_stargazing]
	]
	
	for button_data in buttons:
		var button = find_child(button_data[0])
		if button:
			button.pressed.connect(button_data[1])
			print(button_data[0] + " connected")
		else:
			print(button_data[0] + " not found")
	
	# Initialize progress bars
	update_bars()

func _process(delta):
	# Decrease stats over time
	energy -= ENERGY_DECREASE_RATE * delta
	hunger -= HUNGER_DECREASE_RATE * delta
	happiness -= HAPPINESS_DECREASE_RATE * delta
	strength -= STRENGTH_DECREASE_RATE * delta
	
	# Clamp values
	clamp_values()
	update_bars()

func clamp_values():
	energy = clamp(energy, 0, 10)
	strength = clamp(strength, 0, 10)
	happiness = clamp(happiness, 0, 10)
	hunger = clamp(hunger, 0, 10)

func update_bars():
	if energy_bar:
		energy_bar.value = energy * 10
	if strength_bar:
		strength_bar.value = strength * 10
	if happiness_bar:
		happiness_bar.value = happiness * 10
	if hunger_bar:
		hunger_bar.value = hunger * 10

func _on_spacewalk():
	energy -= 2
	strength += 1
	happiness += 1.5
	hunger -= 1

func _on_zero_gravity():
	energy -= 1.5
	strength += 2
	happiness += 1
	hunger -= 1

func _on_research():
	energy -= 1
	strength -= 0.5
	happiness += 1.5
	hunger -= 0.5

func _on_mining():
	energy -= 2
	strength += 1.5
	happiness += 0.5
	hunger -= 1.5

func _on_eat():
	energy += 1
	hunger += 3
	happiness += 1

func _on_rest():
	energy += 3
	strength -= 0.5
	happiness += 1
	hunger -= 1

func _on_stargazing():
	energy -= 0.5
	happiness += 2
	hunger -= 0.5
