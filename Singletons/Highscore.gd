extends Node

# Handles state between game runs
#
# - The name of the player is stored and presented as default when starting again
# 
# - A list of high scores for each level is stored.

var current_name
var last_score
var pending_score = null

func _init():
	# Ensure the user name is initialised
	get_user_name()


# Set the user name - store it for next run
func set_user_name(user_name):
	current_name = user_name
	var f = FileAccess.open("user://user.txt", FileAccess.WRITE)
	f.store_line(current_name)
	f.close()

# Read the user name - fall back to "Player 1" if no one has played before
func get_user_name():
	if current_name:
		return current_name
	if FileAccess.file_exists("user://user.txt"):
		var f = FileAccess.open("user://user.txt", FileAccess.READ)
		current_name = f.get_line()
		f.close()
	else:
		current_name = "Player 1"
	return current_name

# Create a file name for each level to store high scores
func file_name(level):
	return "user://hiscores%d.data" % level

func get_last_score():
	return last_score


func set_pending_score(details : Dictionary):
	# details expected to contain: level, time, fuel, life, score
	pending_score = details

func get_pending_score():
	return pending_score

# Get the high score for a given level
func get_best(level):
	var scores = read_scores(level)
	if scores.size() > 0:
		return scores[0][0]
	else:
		return -1;

# Add a high score to the list of a level
func add_score(level, score):
	last_score = score
	var scores = read_scores(level)
	scores.append([score, current_name])
	print("Adding score %d for %s" % [score, current_name])
	scores.sort_custom(Callable(SortClass, "sort"))
	if scores.size() > 10:
		scores.resize(10)
	save_scores(level, scores)

# Save high score list
func save_scores(level, scores):
	var filename = file_name(level)
	var f = FileAccess.open_encrypted_with_pass(filename, FileAccess.WRITE, "foo")
	for score in scores:
		var score_string = "%d;%s" % score
		f.store_line(score_string)
	f.close()

# Read high score list
func read_scores(level):
	var filename = file_name(level)
	var list = []
	# Read the encrypted score file if it exists and return a list of [score, name]
	if FileAccess.file_exists(filename):
		var f = FileAccess.open_encrypted_with_pass(filename, FileAccess.READ, "foo") # encrypted file, so players don't cheat.
		while not f.eof_reached():
			var score_string = f.get_line()
			if score_string == "":
				continue
			var split = score_string.split(";", false, 1)
			if split.size() == 2:
				# store as [int_score, name]
				list.append([int(split[0]), (split[1])])
		f.close()
	return list

# Sorter class to sort high score entries [score, player_name]
class SortClass:
	static func sort(a, b):
		return a[0] < b[0]
