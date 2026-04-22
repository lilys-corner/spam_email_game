extends Control
var database: SQLite


var questionNum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Global.incorrectquiz.size())
	database = SQLite.new()
	database.path = "res://questionsData.db"
	database.open_db()
	
	# bam your score is that global variable
	$ScoreLabel.text = "Your Score: " + str(Global.quizscore) + "%"
	
	# display first question
	updateQuestion()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	# if you're done here go back to the main menu
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

func _on_last_question_pressed() -> void:
	#check
	if questionNum == 0:
		pass
		#do nothing. you can't go back
	else:
		#decrement
		questionNum = questionNum - 1
		
		#update
		updateQuestion()

func _on_next_question_pressed() -> void:
	#check
	if(questionNum >= Global.incorrectquiz.size() - 1):
		pass
		# you are not allowedd
	else:
		#increment
		questionNum = questionNum + 1
		updateQuestion()
	#update

func updateQuestion() -> void:
	# our chosen question is whichever one we're on ig
	var qID = Global.incorrectquiz[questionNum]
	
	# get the correct answer number as an int. is it option 1, 2, 3 or 4
	var my_query = "SELECT qCorrect FROM questions WHERE qID = " + str(qID) + ";"
	database.query(my_query)
	var this_correct = database.query_result[0]["qCorrect"]
	var this_ans = "qChoice" + str(this_correct)
	
	# cool now let's get both the question body and the correct answer !!
	# overwrite my_query we don't need the last one anymore
	my_query = "SELECT qBody, " + this_ans + " FROM questions WHERE qID = " + str(qID) + ";"
	database.query(my_query)
	
	# yay we have that. now let's put them in variables
	var quesBody : String = database.query_result[0]["qBody"]
	var quesAns : String = database.query_result[0][this_ans]
	
	#update:
	$wrongQuestion.text = quesBody
	$corrAns.text = quesAns
	
	#var tempnum = questionNum + 1
	#$questionCount.text = "Wrong Question " + str(tempnum) + "/20"
	#^ updating the text box that shows you how far you are
