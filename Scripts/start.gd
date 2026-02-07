extends MarginContainer

var level_list
var high_score_list

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.get_node("HBoxContainer/VBoxContainer/StartButton").connect("button_down", Callable(self, "start"))
	level_list = $HBoxContainer/VBoxContainer2/Levels
	high_score_list = $HBoxContainer/VBoxContainer2/GridContainer
	setup_levels()
	select_level(GlobalState.get_current_level())
	$HBoxContainer/VBoxContainer2/PlayerNameTextEdit.text = Highscore.get_user_name()

func setup_levels():
	level_list.add_item("Level 1",null,true)
	level_list.add_item("Level 2",null,true)
	level_list.add_item("Level 3",null,true)

func current_level():
	return level_list.get_selected_items()[0]

func select_level(index):
	index = max(0,index)
	index = min(level_list.item_count,index)	
	level_list.select(index, true)
	GlobalState.set_current_level(index)
	setup_high_score(index+1)

func setup_high_score(level):
	var list = Highscore.read_scores(level)
	
	var pos = "Pos"
	var time = "Time"
	var pname = "Name"
	var index = 1
	for item in list:
		pos = pos + "\n" + str(index)
		pname = pname + "\n" + item[1]
		time = time + "\n" + str(item[0])
		index = index + 1
	high_score_list.get_node("Label").text = pos
	high_score_list.get_node("Label2").text = time
	high_score_list.get_node("Label3").text = pname

func start():
	var level = current_level()
	Highscore.set_name($HBoxContainer/VBoxContainer2/PlayerNameTextEdit.text)
	match level:
		0: 
			Fade.change_scene_to_file("res://Levels/Level1.tscn")
		1:
			Fade.change_scene_to_file("res://Levels/Level2.tscn")
		2:
			Fade.change_scene_to_file("res://Levels/Level3.tscn")
		

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		start()
	elif Input.is_action_just_pressed("ui_up"):
		select_level(current_level()-1)
	elif Input.is_action_just_pressed("ui_down"):
		select_level(current_level()+1)

func set_current_player_name(user_name: String) -> void:
	Highscore.set_user_name(user_name)
