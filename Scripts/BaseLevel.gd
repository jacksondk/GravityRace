extends Node2D

var start_pos;
var gui
var level

var rocket = preload("res://Rocket.tscn")

func _init(level):
	self.level = level

func new_rocket():
	self.remove_child(self.get_node("Rocket"))
	
	var rocket_instance = rocket.instantiate()
	rocket_instance.set_start_position(start_pos)
	rocket_instance.connect("goal_entered", Callable(self, "reset"))
	rocket_instance.connect("crashed", Callable(self, "reset").bind(false))
	rocket_instance.connect("exit", Callable(self, "exit"))
	self.add_child(rocket_instance)

func reset(goal):
	gui.reset(goal)
	exit()

func exit():
	self.get_tree().change_scene_to_file("res://score.tscn")

func _ready():
	start_pos = self.get_node("Rocket").position
	var best_time = Highscore.get_best(level)
	gui = self.get_node("CanvasLayer/GUI")
	gui.set_level(level)	
	gui.set_best(best_time)
	new_rocket()

func _process(delta):
	pass

func get_drag():
	return 0.1

func get_rotate_speed():
	return 8.8

func get_gravity():
	return Vector2(0,1)*9.8
	
func get_thrust():
	return 10*9.8

func get_start_properties():
	return {'fuel': 200.0, 'max_fuel': 200.0, 'life': 100.0, 'max_life': 100.0}
