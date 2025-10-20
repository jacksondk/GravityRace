extends CharacterBody2D

# The player object login

var start_position
var in_goal = false

var speed = Vector2(0,0)
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

func set_start_position(position):
	start_position = position
	self.position = position

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

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if life <= 0:
		return

	if Input.is_action_pressed("ui_cancel"):
		emit_signal("exit")
	
	if Input.is_action_pressed("ui_right"):
		self.rotate(level_node.get_rotate_speed()*delta)
		started = true
		gui.start()
	if Input.is_action_pressed("ui_left"):
		self.rotate(-level_node.get_rotate_speed()*delta)
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
	
	var collision = self.move_and_collide(speed*delta)
	if collision:
		var collider = collision.get_collider()
		print("Collision with: " + str(collider) + ", class: " + collider.get_class() + ", name: " + collider.name + ", path: " + str(collider.get_path()))
		if powerups and powerups.is_ancestor_of(collider):
			var powup = collision.get_collider()
			powup.apply_powerup(self)
			powup.get_parent().remove_child(powup)
		elif level_node.get_node("Goal") == collider:
			print("Goal ancestor detected!")
			emit_signal("goal_entered", true)
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
			speed = Vector2(0,0)
	gui.set_life(life, max_life)
	

func dead():
	emit_signal("crashed")
