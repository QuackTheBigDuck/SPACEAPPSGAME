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
@onready var energy_bar = $HUD/Energy_Bar
@onready var happiness_bar = $HUD/Happiness_Bar
@onready var hunger_bar = $HUD/Hunger_Bar

func _ready():
	print("SpaceGameHUD script is running")
	
	# Check if all progress bars are found
	if not energy_bar:
		print("Energy_Bar not found")
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
		["Button_Explore", _on_explore],
		["Button_Eat", _on_eat],
		["Button_Rest", _on_rest],
		["Button_Stargazing", _on_stargazing]
	]
	
	for button_data in buttons:
		var button = find_child(button_data[0], true, false)
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
		energy_bar.value = energy * 6
	if happiness_bar:
		happiness_bar.value = happiness * 6
	if hunger_bar:
		hunger_bar.value = hunger * 6

func _on_spacewalk():
	print("Spacewalk button pressed")
	energy -= 2
	strength += 1
	happiness += 1.5
	hunger -= 1
	print("Spacewalk completed")

func _on_zero_gravity():
	print("Zero-gravity exercise button pressed")
	energy -= 1.5
	strength += 2
	happiness += 3
	hunger -= 1
	print("Zero-gravity exercise completed")

func _on_research():
	print("Research and discovery button pressed")
	energy -= 1
	strength -= 0.5
	happiness += 1.5
	hunger -= 0.5
	print("Research and discovery completed")

func _on_mining():
	print("Mining and resource gathering button pressed")
	energy -= 2
	strength += 1.5
	happiness += 0.5
	hunger -= 1.5
	print("Mining and resource gathering completed")

func _on_explore():
	print("Explore galaxy button pressed")
	energy -= 1.5
	happiness += 2
	hunger -= 1
	print("Galaxy exploration completed")

func _on_eat():
	print("Eat button pressed")
	energy += 1
	hunger += 3
	happiness += 1
	print("Meal consumed")

func _on_rest():
	print("Rest button pressed")
	energy += 3
	strength -= 0.5
	happiness += 1
	hunger -= 1
	print("Rest completed")

func _on_stargazing():
	print("Stargazing button pressed")
	energy -= 0.5
	happiness += 2
	hunger -= 0.5
	print("Stargazing session completed")
