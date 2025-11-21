extends MarginContainer

var my_start
var start_time
var last_time = -1
var best_time = -1
var score_label
var best_label
var last_label
var current_level

var speed_label
var speed_progress

var life_label
var life_progress
var fuel_label
var fuel_progress

var started = false

func _ready():
	start_time = Time.get_ticks_msec()
	score_label = self.get_node("HBoxContainer/GridContainer/TimeLabel")
	best_label = self.get_node("HBoxContainer/GridContainer/BestTimeLabel")
	last_label = self.get_node("HBoxContainer/GridContainer/LastTimeLabel")
	
	speed_label = self.get_node("HBoxContainer/StatusContainer/Labels/SpeedLabel")
	speed_progress = self.get_node("HBoxContainer/StatusContainer/ProgressBars/SpeedProgressBar")
	life_label = self.get_node("HBoxContainer/StatusContainer/Labels/LifeLabel")	
	life_progress = self.get_node("HBoxContainer/StatusContainer/ProgressBars/LifeProgressBar")
	fuel_label = self.get_node("HBoxContainer/StatusContainer/Labels/FuelLabel")
	fuel_progress = self.get_node("HBoxContainer/StatusContainer/ProgressBars/FuelProgressBar")

func start():
	if not started:
		start_time = Time.get_ticks_msec()
		started = true

func stop():
	if started:
		started = false

func _process(_delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.	
	if started:
		var current_time = Time.get_ticks_msec() - start_time
		score_label.text = format_time_to_text(current_time)
		if best_time > 0:
			best_label.text = format_time_to_text(best_time)
		if last_time > 0:
			last_label.text = format_time_to_text(last_time)
	
func set_velocity(speed):
	speed_label.text = "%.f" % ((floor(speed/5)*5)/10.0)
	speed_progress.value = speed

func set_life(life, max_life):
	life_label.text = str(life)
	life_progress.value = (life / max_life)*100
	

func set_fuel(fuel, max_fuel):
	fuel_label.text = "%.1f" % fuel
	fuel_progress.value = (fuel/max_fuel)*100

func set_level(level):
	current_level = level

func set_best(time):
	print("Set time %d"% time)
	best_time = time

func reset(record_time):
	var result_time = ((Time.get_ticks_msec() - start_time))
	if record_time and result_time > 1:
		Highscore.add_score(current_level, result_time)
		if best_time < 0 or result_time < best_time:
			best_time = result_time	
		last_time = result_time
	start_time = Time.get_ticks_msec()

func format_time_to_text(time):
	return "%.2f" % (time/1000.0)
	
