extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var pending = null


func goToStartScene():
	self.get_tree().change_scene_to_file("res://start.tscn")


func _ready():
	# If there's a pending score from the last run, show it
	pending = Highscore.get_pending_score()
	if pending:
		$VBox/ScoreValue.text = str(pending.get("score", 0))
		$VBox/Details.text = "Time: %d ms\nFuel: %d\nLife: %d" % [pending.get("time",0), int(pending.get("fuel",0)), int(pending.get("life",0))]
		# default name from saved user name
		$VBox/NameEdit.text = Highscore.get_user_name()
	else:
		$VBox/ScoreValue.text = str(Highscore.get_last_score())
		$VBox/Details.text = ""
		$VBox/NameEdit.text = Highscore.get_user_name()

	$VBox/SaveButton.pressed.connect(Callable(self, "_on_SaveButton_pressed"))
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_action_pressed("ui_cancel"):
		# emulate Save+Return on ESC
		_on_SaveButton_pressed()
	pass


func _on_SaveButton_pressed():
	var name = $VBox/NameEdit.text.strip_edges()
	if name == "":
		name = "Player 1"
	Highscore.set_user_name(name)
	if pending:
		var lvl = pending.get("level", 0)
		var score_val = int(pending.get("score", 0))
		Highscore.add_score(lvl, score_val)
		# clear pending
		Highscore.set_pending_score({})
	goToStartScene()
