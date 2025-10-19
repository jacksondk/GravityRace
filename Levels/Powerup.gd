extends StaticBody2D

@export var extra_fuel: int;
@export var extra_life: int;


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func apply_powerup(rocket):
	rocket.add_fuel(extra_fuel)
	rocket.add_life(extra_life)
