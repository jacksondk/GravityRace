extends CharacterBody2D

# The player object login

var start_position
var in_goal_start = 0
var in_goal = false

var speed = Vector2(0,0)
var rotation_speed = 0

var life
var max_life

#var max_collision_speed = 200
var gui
var fuel
var max_fuel
var extra_drag

var powerups
var level_node
var started = false

signal goal_entered
signal crashed
signal exit

func set_start_position(st_position):
	start_position = st_position
	self.position = st_position

func add_fuel(extra_fuel):
	fuel = min(fuel + extra_fuel, max_fuel)
	
func add_life(extra_life):
	life = min(life + extra_life, max_life)

# Setup game based on the levels properties
func _ready():
	set_physics_process(true)
	gui = self.get_parent().get_node("CanvasLayer/GUI")
	level_node = self.get_parent();

	if level_node.has_node("Powerups"):
		powerups = level_node.get_node("Powerups")
		print("Found %d power ups" % powerups.get_child_count())
	
	var properties = level_node.get_start_properties()
	fuel = properties["fuel"]
	max_fuel = properties["max_fuel"]
	life = properties["life"]
	max_life = properties["max_life"]
	
	# When the goal area signals that we have been there long enough
	# then we finish the level
	var goal = level_node.get_node("Goal")
	if goal:
		goal.connect("player_stayed_long_enough", Callable(self, "finish"))
	
func finish(player = null):
	# Compute elapsed time since level start (ms)
	var elapsed = 0
	if "start_time" in level_node:
		elapsed = Time.get_ticks_msec() - level_node.start_time
	# build a details dictionary with time, fuel, life and score
	var details = {
		"level": level_node.level,
		"time": elapsed,
		"fuel": fuel,
		"life": life,
		"score": int(elapsed) # currently score is just time in ms
	}
	# notify the level to record/transition to score scene
	if level_node.has_method("record_score"):
		level_node.record_score(details)
	else:
		# fallback: emit existing signal
		emit_signal("goal_entered", true)
	
func _process(delta):	
	if life <= 0:
		return
	gui.set_life(life, max_life)
	gui.set_fuel(fuel, max_fuel)

	if Input.is_action_pressed("ui_cancel"):
		emit_signal("exit")
	
	if Input.is_action_pressed("ui_right"):
		rotation_speed += level_node.get_rotate_speed()*delta;		
		started = true
		gui.start()
	if Input.is_action_pressed("ui_left"):
		rotation_speed -= level_node.get_rotate_speed()*delta;		
		started = true
		gui.start()

	var force = level_node.get_gravity()
	if Input.is_action_pressed("ui_up") and fuel > 0:
		gui.start()
		started = true
		var dir_rad = self.get_transform().get_rotation()
		var dir = Vector2(0,-1).rotated(dir_rad)*level_node.get_thrust()
		force = force + dir
		self.get_node("AnimatedSprite2D").play("power")
		if not self.get_node("AudioStreamPlayer").playing:
			self.get_node("AudioStreamPlayer").playing = true
		fuel = fuel-delta*10
		gui.set_fuel(fuel, max_fuel)		
	else:
		self.get_node("AnimatedSprite2D").play("default")
		self.get_node("AudioStreamPlayer").playing = false
		
	extra_drag = 1
	if Input.is_action_pressed("ui_down"):
		extra_drag = 10
	
	if not started:
		return
	force = force - (level_node.get_drag()*extra_drag)*sqrt(speed.dot(speed))*speed.normalized()
	
	speed = speed + force*delta
	gui.set_velocity(floor(speed.length()/5)*5)
	rotation_speed -= rotation_speed*level_node.get_drag()
	
	self.rotate(rotation_speed*delta)
	var collision = self.move_and_collide(speed*delta)
	if not collision:
		in_goal_start = 0
	else:
		var collider = collision.get_collider()
		#print("Collision with: " + str(collider) + ", class: " + collider.get_class() + ", name: " + collider.name + ", path: " + str(collider.get_path()))
		#print("Speed " + str(speed.length()))
		if powerups and powerups.is_ancestor_of(collider):
			var powup = collision.get_collider()
			powup.apply_powerup(self)
			powup.get_parent().remove_child(powup)
		else:
			var collision_speed = floor(speed.length()/5)
			if collision_speed > 5:
				life = life - int(collision_speed)
				gui.set_life(life, max_life)
				if life <= 0:
					life = 0
					self.get_node("AnimatedSprite2D").visible = false
					self.get_node("AudioStreamPlayer2").playing = true
					self.get_node("Timer").connect("timeout", Callable(self, "dead"))
					self.get_node("Timer").start()
				speed = speed.bounce(collision.get_normal())*0.9
			else:
				speed = speed.bounce(collision.get_normal())*0.3

func dead():
	emit_signal("crashed")
