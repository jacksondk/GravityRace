extends SubViewportContainer
#
## class member variables go here, for example:
## var a = 2
## vavr b = "textvar"
#var start 
#var my_start
#var start_time
#var last_time = -1
#var best_time = -1
#
#
#func _ready():
#	# Called every time the node is added to the scene.
#	# Initialization here
#	start = self.get_parent().get_node("Rocket").position
#	my_start = self.rect_position
#	start_time = OS.get_ticks_msec()
#
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	self.rect_position = my_start + self.get_parent().get_node("Rocket").position - start
#	self.get_node("Label").text = format_text()
#
#func set_speed(speed):
#	self.get_node("Speed").text = "%.f" % ((floor(speed/5)*5)/10.0)
#
#func reset(record_time):
#	print("reset %s" % record_time)
#	var result_time = ((OS.get_ticks_msec() - start_time)/1000.0)
#	if record_time and result_time > 1:
#		if best_time < 0 or result_time < best_time:
#			best_time = result_time	
#		last_time = result_time
#	start_time = OS.get_ticks_msec()
#
#func format_text():
#	var current_time = ((OS.get_ticks_msec() - start_time)/1000.0)
#	if best_time > 0:
#		return "Time %.2f\nLast %.2f\nBest %.2f" % [current_time, last_time, best_time]
#	else:
#		return "Time %.2f" % current_time
