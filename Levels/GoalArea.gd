extends Area2D

@export var required_time: float = 1.0  # seconds
# Declare a custom signal
signal player_stayed_long_enough(player: Node)

var player_inside: bool = false
var time_inside: float = 0.0
var current_player: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_inside:
		time_inside += delta		
		if time_inside >= required_time:
			_on_player_stayed_long_enough()
			# Optional: reset to prevent re-trigger
			player_inside = false
			
func _on_player_stayed_long_enough() -> void:	
	emit_signal("player_stayed_long_enough", current_player)

func _on_body_entered(body: Node) -> void:
	if body.name == "Rocket":
		player_inside = true
		time_inside = 0.0
		current_player = body

func _on_body_exited(body: Node) -> void:
	if body.name == "Rocket":
		player_inside = false
		time_inside = 0.0
		current_player = null
