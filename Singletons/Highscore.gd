extends Node

var current_name
var last_score

func _init():
	get_name()
	

func file_name(level):
	return "user://hiscores%d.data" % level

func set_user_name(name):
	current_name = name
	var f = FileAccess.open("user://user.txt", FileAccess.WRITE)
	f.store_line(current_name)

func get_user_name():
	if current_name:
		return current_name
	if FileAccess.file_exists("user://user.txt"):
		var f = FileAccess.open("user://user.txt", FileAccess.READ)
		current_name = f.get_line()
	else:
		current_name = "Player 1"
	return current_name

func get_last_score():
	return last_score

class SortClass:
	static func sort(a, b):
		return a[0] < b[0]

func get_best(level):
	var scores = read_scores(level)
	if scores.size() > 0:
		return scores[0][0]
	else:
		return -1;

func add_score(level, score):
	last_score = score
	var scores = read_scores(level)
	scores.append([score, current_name])
	print("Adding score %d for %s" % [score, current_name])
	scores.sort_custom(Callable(SortClass, "sort"))
	if scores.size() > 10:
		scores.resize(10)
	save_scores(level, scores)

func save_scores(level, scores):
	var filename = file_name(level)
	var f = FileAccess.open_encrypted_with_pass(filename, FileAccess.WRITE, "foo")
	for score in scores:
		var score_string = "%d;%s" % score
		f.store_line(score_string)

func read_scores(level):	
	var filename = file_name(level)
	var list = []
	# if(FileAccess.file_exists(filename)):
	if false:
		var f = FileAccess.open_encrypted_with_pass(filename,FileAccess.READ,"foo") #encrypted file, so players don't cheat.
		while not f.eof_reached():
			var score_string = f.get_line()
			var split = score_string.split(";",false, 1)
			if split.size() == 2:
				list.append([int(split[0]), (split[1])])
	return list
