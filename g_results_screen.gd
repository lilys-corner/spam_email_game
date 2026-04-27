extends Control

# Variables
var database: SQLite
var emailNum = 0

func _ready() -> void:
	# To retrieve question information for wrongly answered emails
	database = SQLite.new()
	database.path = "res://questionsData.db"
	database.open_db()
	
	# Set the score to the quizscore global variable
	$ScoreLabel.text = str(Global.gamescore) + "%"
	
	# If there are misidentified emails, display the first one
	if (Global.incorrectgame.size() != 0):
		updateQuestion()

func _process(delta: float) -> void:
	pass

# Return to the main menu
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

# BACK button
func _on_last_email_pressed() -> void:
	# Check if the current email is the first one
	if emailNum == 0:
		pass
		# You cannot go back on the first email
	else:
		# Go to the previous email and update the information
		emailNum = emailNum - 1
		updateQuestion()

# NEXT button
func _on_next_email_pressed() -> void:
	# Check if the current email is the last one
	if(emailNum >= Global.incorrectgame.size() - 1):
		pass
		# You cannot go forward on the last email
	else:
		# Go to the next email and update the information
		emailNum = emailNum + 1
		updateQuestion()

# Update the text boxes to reflect the current email
func updateQuestion() -> void:
	# The email ID of our current email
	var emailID = Global.incorrectgame[emailNum]
	
	# Get the correct answer as an int, is it not spam (0) or spam (1)?
	var my_query = "SELECT * FROM emails WHERE emailID = " + str(emailID) + ";"
	database.query(my_query)
	var this_correct = database.query_result[0]["emailAnswer"]
	
	var emailFrom : String = database.query_result[0]["emailAddress"]
	var emailSubj : String = database.query_result[0]["emailSubject"]
	var emailBody : String = database.query_result[0]["emailBody"]
	var quesAns : String
	
	# Determine if the answer is if it's not spam (0) or if it is (1)
	if (database.query_result[0]["emailAnswer"] == 0):
		quesAns = "This email is not spam."
	else:
		quesAns = "This email is spam."
	
	# Update text boxes
	$wrongFrom.text = emailFrom
	$wrongSubj.text = emailSubj
	$wrongBody.text = emailBody
	$corrAns.text = quesAns
