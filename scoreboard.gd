extends Control
var account_db

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#basically this is where we pull the top scores (top 10?)
	#from the database
	#and then put them into a bunch of rich text labels or just labels
	$tempLabel.text = "SCOREBOARD PAGE"
	
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"
	
	# open the database so we can get stuff
	account_db.open_db()
	
	# perform a queryyyy
	# we will retrieve from the game_scores data table:
	# score id, game score, then username in descending order of scores (first is highest)
	# we will only be using the first 10
	account_db.query("SELECT username, score FROM game_scores JOIN accounts ON game_scores.ID = accounts.ID ORDER BY score")
	# we now have each entry's first value is username, second is score stored in query_result
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
