extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func goToStartScene():
	self.get_tree().change_scene_to_file("res://start.tscn")


func _ready():
	$HBoxContainer/Score.text = str(Highscore.get_last_score())
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_action_pressed("ui_cancel"):
		goToStartScene();
	pass
