extends MarginContainer

var pending = null

func goToStartScene():
	Fade.change_scene_to_file("res://UIScenes/start.tscn")


func _ready():
	# If there's a pending score from the last run, show it
	pending = Highscore.get_pending_score()
	if pending:
		var score_val = int(pending.get("score", 0))
		$VBox/ScoreValue.text = str(score_val)
		$VBox/Details.text = "Time: %d ms\nFuel: %d\nLife: %d" % [pending.get("time",0), int(pending.get("fuel",0)), int(pending.get("life",0))]
		$VBox/PositionValue.text = _get_highscore_position_text(pending)
		# default name from saved user name
		$VBox/NameEdit.text = Highscore.get_user_name()
	else:
		$VBox/ScoreValue.text = str(Highscore.get_last_score())
		$VBox/Details.text = ""
		$VBox/PositionValue.text = "-"
		$VBox/NameEdit.text = Highscore.get_user_name()

	$VBox/SaveButton.pressed.connect(Callable(self, "_on_SaveButton_pressed"))
	$VBox/NameEdit.text_submitted.connect(Callable(self, "_on_NameEdit_submitted"))
	$VBox/NameEdit.grab_focus()
	

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


func _on_NameEdit_submitted(_new_text: String) -> void:
	# Treat Enter in the name field as Save + Return.
	_on_SaveButton_pressed()


func _get_highscore_position_text(details: Dictionary) -> String:
	var lvl = int(details.get("level", 0))
	var score_val = int(details.get("score", 0))
	var scores = Highscore.read_scores(lvl)
	var name = Highscore.get_user_name()
	scores.append([score_val, name, ""])
	scores.sort_custom(Callable(Highscore.SortClass, "sort"))
	var rank = -1
	for i in range(scores.size()):
		if int(scores[i][0]) == score_val and str(scores[i][1]) == name:
			rank = i + 1
			break
	if rank < 0:
		return "-"
	if rank > 10:
		return "#%d (outside top 10)" % rank
	return "#%d" % rank
