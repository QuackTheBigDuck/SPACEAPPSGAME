extends Area2D

var velocity = Vector2.ZERO
var pull_speed = 100
var rotation_speed = 0

# Array of debris texture paths
var debris_textures = [
	"res://assets/images/blackhole_MG/ast1",
	"res://assets/images/blackhole_MG/ast2",
	# Add paths to all your debris images
]

func _ready():
	# Connect the body_entered signal
	connect("body_entered", _on_body_entered)
	
	# Randomize rotation speed
	rotation_speed = randf_range(-2, 2)
	
	# Select and set a random debris texture
	if debris_textures.size() > 0:
		var random_texture_path = debris_textures[randi() % debris_textures.size()]
		var texture = load(random_texture_path)
		if texture:
			$Sprite2D.texture = texture
			
			# Randomize the scale
			var random_scale = randf_range(0.3, 0.8)
			$Sprite2D.scale = Vector2(random_scale, random_scale)

func _process(delta):
	var black_hole_pos = get_node("/root/Node/bh").position
	var direction = (black_hole_pos - position).normalized()
	
	velocity += direction * pull_speed * delta
	position += velocity * delta
	
	# Rotate the debris
	rotation += rotation_speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Get the main game node and call _on_player_hit
		var game_node = get_node("/root/Node")
		if game_node:
			game_node._on_player_hit()
		# Remove the debris after hitting the player
		queue_free()
