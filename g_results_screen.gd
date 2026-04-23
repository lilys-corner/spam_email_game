extends Control
var database: SQLite

var emailNum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Global.incorrectgame.size())
	database = SQLite.new()
	database.path = "res://questionsData.db"
	database.open_db()
	
	# bam your score is that global variable
	$ScoreLabel.text = str(Global.gamescore) + "%"
	
	# display first question
	updateQuestion()

func _process(delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	# if you're done here go back to the main menu
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

func _on_last_email_pressed() -> void:
	#check
	if emailNum == 0:
		pass
		#do nothing. you can't go back
	else:
		#decrement
		emailNum = emailNum - 1
		
		#update
		updateQuestion()

func _on_next_email_pressed() -> void:
	#check
	if(emailNum >= Global.incorrectgame.size() - 1):
		pass
	else:
		#increment
		emailNum = emailNum + 1
		updateQuestion()
	#update

func updateQuestion() -> void:
	# our chosen question is whichever one we're on ig
	var emailID = Global.incorrectgame[emailNum]
	
	# get the correct answer number as an int. is it option 1, 2, 3 or 4
	var my_query = "SELECT * FROM emails WHERE emailID = " + str(emailID) + ";"
	database.query(my_query)
	var this_correct = database.query_result[0]["emailAnswer"]
	
	# yay we have that. now let's put them in variables
	var emailFrom : String = database.query_result[0]["emailAddress"]
	var emailSubj : String = database.query_result[0]["emailSubject"]
	var emailBody : String = database.query_result[0]["emailBody"]
	var quesAns : String
	if (database.query_result[0]["emailAnswer"] == 0):
		quesAns = "No, this email is not spam."
	else:
		quesAns = "Yes, this email is spam."
	
	#update:
	$wrongFrom.text = emailFrom
	$wrongSubj.text = emailSubj
	$wrongBody.text = emailBody
	$corrAns.text = quesAns
