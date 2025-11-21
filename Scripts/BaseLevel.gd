extends Node2D

var rocket_start_pos;
var gui
var level
var start_time = 0
var level_tree

func _init(_level):
	self.level = _level
	level_tree = get_tree()

func _ready():
	rocket_start_pos = self.get_node("Rocket").position
	var best_time = Highscore.get_best(level)
	gui = self.get_node("CanvasLayer/GUI")
	gui.set_level(level)
	gui.set_best(best_time)
	new_rocket()

func _process(_delta: float):
	if Input.is_action_pressed("ui_cancel"):
		Fade.change_scene_to_file("res://start.tscn")
	if Input.is_action_pressed("ui_home"):
		new_rocket()

func new_rocket():
	# record the time the run started
	var rocket = get_node("Rocket")
	rocket.reset_to_start()
	gui.stop()
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
	Fade.change_scene_to_file("res://score.tscn")

func exit():
	Fade.change_scene_to_file("res://score.tscn")

@export var drag : float = 0.1
@export var gravity : Vector2 = Vector2(0,1)*9.8
@export var thrust : float = 10*9.8
@export var rotate_speed : float = 15

func get_start_properties():
	return {'fuel': 200.0, 'max_fuel': 200.0, 'life': 100.0, 'max_life': 100.0}
