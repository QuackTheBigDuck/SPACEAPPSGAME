extends Node

var Debris = preload("res://scenes/BlackHole_MG/Debris.tscn")
var game_duration = 60  # 1 minute
var time_left = game_duration
var game_over = false
var score = 0
var player_health = 5

var debris_manager: Node2D

func _ready():
	$bh.play("new_animation")
	setup_debris_manager()
	setup_ui()
	start_game()
	$CharacterBody2D.add_to_group("player")
	
	# Set up the spawn timer
	var spawn_timer = Timer.new()
	spawn_timer.set_wait_time(1.0)  # Spawn debris every second
	spawn_timer.set_one_shot(false)
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()

func setup_ui():
	# Create health label
	var health_label = Label.new()
	health_label.name = "HealthLabel"
	health_label.text = "Health: 5"
	health_label.position = Vector2(20, 20)
	# Make the health label bigger and more visible
	health_label.add_theme_color_override("font_color", Color(1, 0, 0)) # Red color
	health_label.add_theme_font_size_override("font_size", 24) # Bigger font
	add_child(health_label)
	
	# Create game over label (hidden initially)
	var game_over_label = Label.new()
	game_over_label.name = "GameOverLabel"
	game_over_label.text = "Game Over!"
	game_over_label.hide()
	# Make the game over label bigger and more visible
	game_over_label.add_theme_color_override("font_color", Color(1, 0, 0)) # Red color
	game_over_label.add_theme_font_size_override("font_size", 48) # Much bigger font
	add_child(game_over_label)

func _process(delta):
	if game_over:
		return
	
	handle_player_movement(delta)
	update_timer(delta)
	move_debris(delta)
	update_ui()

func setup_debris_manager():
	debris_manager = $DebrisManager if has_node("DebrisManager") else null
	if debris_manager == null:
		debris_manager = Node2D.new()
		debris_manager.name = "DebrisManager"
		add_child(debris_manager)
	print("DebrisManager setup complete")

func start_game():
	time_left = game_duration
	game_over = false
	score = 0
	player_health = 5
	$Timer.start()
	if has_node("GameOverLabel"):
		$GameOverLabel.hide()

func handle_player_movement(delta):
	if game_over:
		return
		
	var player = $CharacterBody2D
	var movement = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		movement.x += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	
	# Apply movement
	player.velocity = movement.normalized() * 300
	
	# The move_and_slide() function will automatically handle collisions
	player.move_and_slide()

func update_timer(delta):
	time_left -= delta
	if time_left <= 0:
		win_game()

func spawn_debris():
	var debris = Debris.instantiate()
	
	# Randomize starting position on the edge of the screen
	var viewport_rect = get_viewport().get_visible_rect()
	var spawn_position = Vector2.ZERO
	match randi() % 4:
		0: # Top
			spawn_position = Vector2(randf_range(0, viewport_rect.size.x), -50)
		1: # Right
			spawn_position = Vector2(viewport_rect.size.x + 50, randf_range(0, viewport_rect.size.y))
		2: # Bottom
			spawn_position = Vector2(randf_range(0, viewport_rect.size.x), viewport_rect.size.y + 50)
		3: # Left
			spawn_position = Vector2(-50, randf_range(0, viewport_rect.size.y))
	
	debris.position = spawn_position
	debris_manager.add_child(debris)

func move_debris(delta):
	if debris_manager == null:
		return
	
	var black_hole_position = $bh.global_position
	for debris in debris_manager.get_children():
		var direction = (black_hole_position - debris.global_position).normalized()
		debris.position += direction * 100 * delta  # Adjust speed as needed

func _on_spawn_timer_timeout():
	if !game_over:
		spawn_debris()

func win_game():
	game_over = true
	print("You win!")
	# Add win game logic here

func lose_game():
	game_over = true
	print("Game Over!")
	
	if has_node("GameOverLabel"):
		$GameOverLabel.show()
		$GameOverLabel.text = "Game Over!"
		# Center the label on screen
		$GameOverLabel.position = Vector2(
			get_viewport().size.x / 2 - $GameOverLabel.size.x / 2,
			get_viewport().size.y / 2 - $GameOverLabel.size.y / 2
		)
	
	# Stop spawning debris
	for timer in get_children():
		if timer is Timer:
			timer.stop()
	
	# Clear existing debris
	if debris_manager:
		for debris in debris_manager.get_children():
			debris.queue_free()
			
	# Optionally, you can disable player movement here
	$CharacterBody2D.set_physics_process(false)

func _on_player_hit():
	if game_over:
		return
		
	player_health -= 1
	print("Player hit! Health remaining: ", player_health)
	
	# Update UI immediately
	update_ui()
	
	if player_health <= 0:
		lose_game()

func _on_debris_body_entered(body):
	if body.is_in_group("player"):
		_on_player_hit()

func update_ui():
	if has_node("HealthLabel"):
		$HealthLabel.text = "Health: " + str(player_health)
