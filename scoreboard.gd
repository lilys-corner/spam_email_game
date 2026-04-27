extends Control
var account_db

func _ready() -> void:
	# DATABASE PULL
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"
	
	account_db.open_db()
	
	# QUIZ LEADERBOARD----------------------->>
	$qBoard/tier1/username.text = ""
	$qBoard/tier1/score.text = ""
	#tier 2
	$qBoard/tier2/username.text = ""
	$qBoard/tier2/score.text = ""
	# rank 3
	$qBoard/tier3/username.text = ""
	$qBoard/tier3/score.text = ""
	# rank 4
	$qBoard/tier4/username.text = ""
	$qBoard/tier4/score.text = ""
	# rank 5
	$qBoard/tier5/username.text = ""
	$qBoard/tier5/score.text = ""
	# rank 6
	$qBoard/tier6/username.text = ""
	$qBoard/tier6/score.text = ""
	# rank 7
	$qBoard/tier7/username.text = ""
	$qBoard/tier7/score.text = ""
	#E
	# rank 8
	$qBoard/tier8/username.text = ""
	$qBoard/tier8/score.text = ""
	# rank 9
	$qBoard/tier9/username.text = ""
	$qBoard/tier9/score.text = ""
	# rank 10
	$qBoard/tier10/username.text = ""
	$qBoard/tier10/score.text = ""
	
	# DATABASE Query for selecting top 10
	account_db.query("SELECT username, score FROM quiz_scores JOIN accounts ON quiz_scores.ID = accounts.ID ORDER BY score DESC;")
	# we now have each entry's first value is username, second is score stored in query_result
	fill_quiz()
	
	# GAME LEADERBOARD----------------------->>
	$gBoard/tier1/username.text = ""
	$gBoard/tier1/score.text = ""
	#tier 2
	$gBoard/tier2/username.text = ""
	$gBoard/tier2/score.text = ""
	# rank 3
	$gBoard/tier3/username.text = ""
	$gBoard/tier3/score.text = ""
	# rank 4
	$gBoard/tier4/username.text = ""
	$gBoard/tier4/score.text = ""
	# rank 5
	$gBoard/tier5/username.text = ""
	$gBoard/tier5/score.text = ""
	# rank 6
	$gBoard/tier6/username.text = ""
	$gBoard/tier6/score.text = ""
	# rank 7
	$gBoard/tier7/username.text = ""
	$gBoard/tier7/score.text = ""
	# rank 8
	$gBoard/tier8/username.text = ""
	$gBoard/tier8/score.text = ""
	# rank 9
	$gBoard/tier9/username.text = ""
	$gBoard/tier9/score.text = ""
	# rank 10
	$gBoard/tier10/username.text = ""
	$gBoard/tier10/score.text = ""
	
	#Database Query
	account_db.query("SELECT username, score FROM game_scores JOIN accounts ON game_scores.ID = accounts.ID ORDER BY score DESC;")
	# we now have each entry's first value is username, second is score stored in query_result
	fill_game()
	
	account_db.close_db()

func _process(delta: float) -> void:
	pass

# Return to the main menu
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

# Fill in Quiz Leaderboard
func fill_quiz() -> void:
	if not account_db.query_result:
		return
	
	var size = account_db.query_result.size()
	
	if (size >= 1):
		$qBoard/tier1/username.text = account_db.query_result[0]["username"]
		$qBoard/tier1/score.text = str(account_db.query_result[0]["score"])
	if (size >= 2):
		$qBoard/tier2/username.text = account_db.query_result[1]["username"]
		$qBoard/tier2/score.text = str(account_db.query_result[1]["score"])
	if (size >= 3):
		$qBoard/tier3/username.text = account_db.query_result[2]["username"]
		$qBoard/tier3/score.text = str(account_db.query_result[2]["score"])
	if (size >= 4):
		$qBoard/tier4/username.text = account_db.query_result[3]["username"]
		$qBoard/tier4/score.text = str(account_db.query_result[3]["score"])
	if (size >= 5):
		$qBoard/tier5/username.text = account_db.query_result[4]["username"]
		$qBoard/tier5/score.text = str(account_db.query_result[4]["score"])
	if (size >= 6):
		$qBoard/tier6/username.text = account_db.query_result[5]["username"]
		$qBoard/tier6/score.text = str(account_db.query_result[5]["score"])
	if (size >= 7):
		$qBoard/tier7/username.text = account_db.query_result[6]["username"]
		$qBoard/tier7/score.text = str(account_db.query_result[6]["score"])
	if (size >= 8):
		$qBoard/tier8/username.text = account_db.query_result[7]["username"]
		$qBoard/tier8/score.text = str(account_db.query_result[7]["score"])
	if (size >= 9):
		$qBoard/tier9/username.text = account_db.query_result[8]["username"]
		$qBoard/tier9/score.text = str(account_db.query_result[8]["score"])
	if (size >= 10):
		$qBoard/tier10/username.text = account_db.query_result[9]["username"]
		$qBoard/tier10/score.text = str(account_db.query_result[9]["score"])

#Fill in Game Leaderboard
func fill_game() -> void:
	if not account_db.query_result:
		return
	
	var size = account_db.query_result.size()
	
	if (size >= 1):
		$gBoard/tier1/username.text = account_db.query_result[0]["username"]
		$gBoard/tier1/score.text = str(account_db.query_result[0]["score"])
	if (size >= 2):
		$gBoard/tier2/username.text = account_db.query_result[1]["username"]
		$gBoard/tier2/score.text = str(account_db.query_result[1]["score"])
	if (size >= 3):
		$gBoard/tier3/username.text = account_db.query_result[2]["username"]
		$gBoard/tier3/score.text = str(account_db.query_result[2]["score"])
	if (size >= 4):
		$gBoard/tier4/username.text = account_db.query_result[3]["username"]
		$gBoard/tier4/score.text = str(account_db.query_result[3]["score"])
	if (size >= 5):
		$gBoard/tier5/username.text = account_db.query_result[4]["username"]
		$gBoard/tier5/score.text = str(account_db.query_result[4]["score"])
	if (size >= 6):
		$gBoard/tier6/username.text = account_db.query_result[5]["username"]
		$gBoard/tier6/score.text = str(account_db.query_result[5]["score"])
	if (size >= 7):
		$gBoard/tier7/username.text = account_db.query_result[6]["username"]
		$gBoard/tier7/score.text = str(account_db.query_result[6]["score"])
	if (size >= 8):
		$gBoard/tier8/username.text = account_db.query_result[7]["username"]
		$gBoard/tier8/score.text = str(account_db.query_result[7]["score"])
	if (size >= 9):
		$gBoard/tier9/username.text = account_db.query_result[8]["username"]
		$gBoard/tier9/score.text = str(account_db.query_result[8]["score"])
	if (size >= 10):
		$gBoard/tier10/username.text = account_db.query_result[9]["username"]
		$gBoard/tier10/score.text = str(account_db.query_result[9]["score"])
