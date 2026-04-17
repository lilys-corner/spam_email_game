extends Control
var database: SQLite

#ok so you gotta put your variables up here so the program doesn't
#scream at you
#maybe have a total question variable that can be adjusted
#with user input?
var totalQuestion = 20
var correctCount = 0
var questionNum = 0
var questionSet = []
var answerSet = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
#assuming I can count that is 20 0s. if we change the number of questions we will have to change that too
#0: no answer selected
#we will want the submit button to check and see if there are any 0s left
var rng = RandomNumberGenerator.new()

#adding a default score for the quiz mode which is 0
var quizscore = 0

var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
var select = preload("res://assets/quiz_mode/opt_selected.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path = "res://questionsData.db" #would want to be using user:// for saves
	database.open_db()
	#get numbers of each question, put IDs in array
	#initialize question ID array
	#randomize numbers and fill in array
	for i in range(0, 19):
		pass
		#questionSet[i] = rng.randi_range(1, 1) #not a clue how many entries we will have
		#uhhh task for someone who has access to the database: adjust the question number
		#based on how many there are
		#in the randi_range() function
	

	#retrieve information for first question
	#var quesBody = database.select_rows ("questions", "qID = 1", ["qBody"])
	#var quesBodytxt : String = quesBody[0]["qBody"]
	var questionData = database.select_rows("questions", "qID = 1", ["*"])
	var quesBody : String = questionData[0]["qBody"]
	var quesChoice1 : String = questionData[0]["qChoice1"]
	var quesChoice2 : String = questionData[0]["qChoice2"]
	var quesChoice3 : String = questionData[0]["qChoice3"]
	var quesChoice4 : String = questionData[0]["qChoice4"]
	#var quesChoice1 = database.select_rows ("questions", "qID = 1", ["qChoice1"])
	#var quesChoice2 = database.select_rows ("questions", "qID = 1", ["qChoice2"])
	#var quesChoice3 = database.select_rows ("questions", "qID = 1", ["qChoice3"])
	#var quesChoice4 = database.select_rows ("questions", "qID = 1", ["qChoice4"])
	#var quesCorrect = database.select_rows ("questions", "qID = 1", ["qCorrect"])
	
	
	#update labels
	#$questionItself.text = "QUESTION HERE"
	#$aChoicebox/HBoxContainer/answer1.text = "AAAAA"
	#$aChoicebox/HBoxContainer2/answer2.text = "BBBBB"
	#$aChoicebox/HBoxContainer3/answer3.text = "C"
	#$aChoicebox/HBoxContainer4/answer4.text = "DEFGHIJKLMNOP"
	$questionItself.text = quesBody
	$aChoicebox/HBoxContainer/answer1.text = quesChoice1
	$aChoicebox/HBoxContainer2/answer2.text = quesChoice2
	$aChoicebox/HBoxContainer3/answer3.text = quesChoice3
	$aChoicebox/HBoxContainer4/answer4.text = quesChoice4
	var tempnum = questionNum + 1
	$questionCount.text = "Question " + str(tempnum) + "/20"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_to_menutemp_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")


func _on_prev_q_pressed() -> void:
	#check
	if questionNum == 1:
		pass
		#do nothing. you can't go back. unless we want you to be able to quit out of the quiz.
	else:
		#decrement
		questionNum = questionNum - 1
		
		#update
		updateQuestion()


func _on_next_q_pressed() -> void:
	#check
	if(questionNum == 19):
		#change texture to submit button
		
		#check if all answers are filled
		var allChecked = true
		for i in range(0, 19):
			if(answerSet[i] == 0):
				#you have not answered every question and there will be a warning
				allChecked = false
				#maybe get a warning
				
				#append each question that you haven't checked to a string and display it afterwards
				
		#obligatory are you sure you want to submit warning
	else:
		#increment
		questionNum = questionNum + 1
	#update

func updateQuestion() -> void:
	var qID = questionSet[questionNum]
	
	#retrieve data
	#ADD DATA RETRIEVAL FOR THIS PARTICULAR QUESTION HERE
	
	#update:
	#assign the text retrieved from the database to the text boxes
	#currently there's temporary info here
	$questionItself.text = "c"
	$aChoicebox/HBoxContainer/answer1.text = "AAAAA"
	$aChoicebox/HBoxContainer2/answer2.text = "BBBBB"
	$aChoicebox/HBoxContainer3/answer3.text = "C"
	$aChoicebox/HBoxContainer4/answer4.text = "DEFGHIJKLMNOP"
	
	var tempnum = questionNum + 1
	$questionCount.text = "Question " + str(tempnum) + "/20"
	#^ updating the text box that shows you how far you are
	


func _on_option_a_pressed() -> void:
	#set current selected answer to 1
	answerSet[questionNum] = 1
	#set this sprite to different sprite
	
	#draft code for adding number to score, Correct values as we get database together - Shay
	#for now I was thinking depending on the question number each value will add up to 100 for a max score
	#if(answerSet[questionNum] == questions.answer(qID)): #placeholder, replace when quiz database complete
		#correctCount+=1
		
	#Current thoughts are that we just calculate it out at the end I feel like that would be much easier
	#as far as scoring goes so it doesn't need to recalculate whenever the player picks a different option
	#we can just make a second array that pulls the correct number every time you load a question if necessary
	
	
	
#score calculation function
func ScoreCalc() -> void:
	quizscore = (correctCount/totalQuestion)*100
	


func SubmitToLeaderboard() -> void:
	pass
	#insert code to import value quizscore to database
	#leaderboard name should be linked to logged in user
	
func clearOpt() -> void:
	#resets the sprites of all options when you change questions forwards or back actually
	$aChoiceBox/HboxContainer/optionA.texture = nonSelect
	$aChoicebox/HBoxContainer2/optionB.texture = nonSelect
	$aChoicebox/HBoxContainer3/optionC.texture = nonSelect
	$aChoicebox/HBoxContainer4/optionD.texture = nonSelect
	
	if answerSet[questionNum] == 1:
		$aChoiceBox/HboxContainer/optionA.texture = select
	elif answerSet[questionNum] == 2:
		$aChoicebox/HBoxContainer2/optionB.texture = select
	elif answerSet[questionNum] == 3:
		$aChoicebox/HBoxContainer3/optionC.texture = select
	elif answerSet[questionNum] == 4:
		$aChoicebox/HBoxContainer4/optionD.texture = select
