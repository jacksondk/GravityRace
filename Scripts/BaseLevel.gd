extends Node2D

var start_pos;
var gui
var level
var start_time = 0
var level_tree

var rocket = preload("res://Rocket.tscn")

func _init(_level):
	self.level = _level
	level_tree = get_tree()

func new_rocket():
	#self.remove_child(self.get_node("Rocket"))	
	#var rocket_instance = rocket.instantiate()
	#rocket_instance.set_start_position(start_pos)
	#rocket_instance.connect("goal_entered", Callable(self, "reset"))
	#rocket_instance.connect("crashed", Callable(self, "reset").bind(false))
	#rocket_instance.connect("exit", Callable(self, "exit"))
	#self.add_child(rocket_instance)

	# record the time the run started
	start_time = Time.get_ticks_msec()

func reset(goal):
	# gui may be null in some cases (e.g., scene not fully initialised). Guard against that.
	if gui:
		if "reset" in gui:
			gui.reset(goal)
		else:
			print("GUI node has no reset() method")
	else:
		print("Warning: gui is null in BaseLevel.reset()")
	exit()


func record_score(details):
	# details should be a Dictionary containing level, time, fuel, life, score
	Highscore.set_pending_score(details)
	get_tree().change_scene_to_file("res://score.tscn")

func exit():
	get_tree().change_scene_to_file("res://score.tscn")

func _ready():
	start_pos = self.get_node("Rocket").position
	var best_time = Highscore.get_best(level)
	gui = self.get_node("CanvasLayer/GUI")
	gui.set_level(level)	
	gui.set_best(best_time)
	new_rocket()

func _process(_delta):
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
