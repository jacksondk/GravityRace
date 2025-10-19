extends "BaseLevel.gd"

func _init():
	super(1)
	pass
#var start_pos;
#var gui

#func new_rocket():
#	self.remove_child(self.get_node("Rocket"))
#	var rocket_instance = rocket.instance()
#	rocket_instance.set_start_position(start_pos)
#	rocket_instance.connect("goal_entered", self, "reset")
#	rocket_instance.connect("crashed", self, "reset", [false])
#	rocket_instance.connect("exit", self, "exit")
#	self.add_child(rocket_instance)
#
#var rocket = preload("res://Rocket.tscn")
#func reset(goal):
#	gui.reset(goal)
#	new_rocket()
#
#func exit():
#	self.get_tree().change_scene("res://start.tscn")
#
#func _ready():
#	start_pos = self.get_node("Rocket").position
#	gui = self.get_node("CanvasLayer/GUI")
#	gui.set_level(0)
#	var best_time = Highscore.get_best(0)
#	gui.set_best(best_time)
#	new_rocket()
#
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
