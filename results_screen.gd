extends Control

#Variables
var database: SQLite
var questionNum = 0

func _ready() -> void:
	# To retrieve question information for wrongly answered questions
	database = SQLite.new()
	database.path = "res://questionsData.db"
	database.open_db()
	
	# Set the score to the quizscore global variable
	$ScoreLabel.text = str(Global.quizscore) + "%"
	
	# If there are incorrect questions, display the first one
	if (Global.incorrectquiz.size() != 0):
		updateQuestion()

func _process(delta: float) -> void:
	pass

# Return to the main meenu
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

# BACK button
func _on_last_question_pressed() -> void:
	# Check if the current question is the first one
	if questionNum == 0:
		pass
		# You cannot go back on the first question
	else:
		# Go to the previous question and update the information
		questionNum = questionNum - 1
		updateQuestion()

# NEXT button
func _on_next_question_pressed() -> void:
	# Check if the current question is the last one
	if(questionNum >= Global.incorrectquiz.size() - 1):
		pass
		# You cannot go forward on the last question
	else:
		# Go to the next question and update the information
		questionNum = questionNum + 1
		updateQuestion()

# Update the text boxes to reflect the current question
func updateQuestion() -> void:
	# The question ID of our current question
	var qID = Global.incorrectquiz[questionNum]
	
	# Get the correct answer number as an int, is it option 1, 2, 3 or 4?
	var my_query = "SELECT qCorrect FROM questions WHERE qID = " + str(qID) + ";"
	database.query(my_query)
	var this_correct = database.query_result[0]["qCorrect"]
	var this_ans = "qChoice" + str(this_correct)
	
	# Receive the question body and correct answer
	my_query = "SELECT qBody, " + this_ans + " FROM questions WHERE qID = " + str(qID) + ";"
	database.query(my_query)
	
	var quesBody : String = database.query_result[0]["qBody"]
	var quesAns : String = database.query_result[0][this_ans]
	
	# Update text boxes
	$wrongQuestion.text = quesBody
	$corrAns.text = quesAns
