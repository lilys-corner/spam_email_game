extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#basically this is where we pull the top scores (top 10?)
	#from the database
	#and then put them into a bunch of rich text labels or just labels
	$tempLabel.text = "SCOREBOARD PAGE"
	
	# DATABASE PULL
	
	# WHOO labels and the like
	#Oh god there's so many
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
	# rank 8
	$qBoard/tier8/username.text = ""
	$qBoard/tier8/score.text = ""
	# rank 9
	$qBoard/tier9/username.text = ""
	$qBoard/tier9/score.text = ""
	# rank 10
	$qBoard/tier10/username.text = ""
	$qBoard/tier10/score.text = ""
	
	
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
