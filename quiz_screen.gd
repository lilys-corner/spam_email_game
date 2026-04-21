extends Control
var database: SQLite
var account_db

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

var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
var select = preload("res://assets/quiz_mode/opt_selected.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path = "res://questionsData.db" #would want to be using user:// for saves
	database.open_db()
	questionSet.resize(20)
	print(questionSet)

	#get numbers of each question, put IDs in array
	#initialize question ID array
	#randomize numbers and fill in array
	for i in range(0, 20):
		#pass
		var temp_val = rng.randi_range(0, 39) #not a clue how many entries we will have
		print("Before reroll", temp_val)
		#uhhh task for someone who has access to the database: adjust the question number
		#based on how many there are
		#in the randi_range() function
		
		while questionSet.has(temp_val):
			temp_val = rng.randi_range(0, 39)
			print("After reroll", temp_val)
		questionSet[i] = temp_val
		
	print(questionSet)
	var qID = questionSet[questionNum]
	#retrieve information for first question
	var questionData = database.select_rows("questions", "qID = qID", ["*"])
	var quesBody : String = questionData[qID]["qBody"]
	var quesChoice1 : String = questionData[qID]["qChoice1"]
	var quesChoice2 : String = questionData[qID]["qChoice2"]
	var quesChoice3 : String = questionData[qID]["qChoice3"]
	var quesChoice4 : String = questionData[qID]["qChoice4"]
	
	
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
	if questionNum == 0:
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
		checkAllAnswers()
		#obligatory are you sure you want to submit warning
	else:
		#increment
		questionNum = questionNum + 1
		updateQuestion()
	#update

func updateQuestion() -> void:
	var qID = questionSet[questionNum]
	#var qID = questionNum
	print(questionNum)
	var questionData = database.select_rows("questions", "qID = qID", ["*"])
	print(qID)
	var quesBody : String = questionData[qID]["qBody"]
	var quesChoice1 : String = questionData[qID]["qChoice1"]
	var quesChoice2 : String = questionData[qID]["qChoice2"]
	var quesChoice3 : String = questionData[qID]["qChoice3"]
	var quesChoice4 : String = questionData[qID]["qChoice4"]
	print(questionSet)
	#retrieve data
	#ADD DATA RETRIEVAL FOR THIS PARTICULAR QUESTION HERE
	
	#update:
	#assign the text retrieved from the database to the text boxes
	#currently there's temporary info here
	#$questionItself.text = "c"
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
	#^ updating the text box that shows you how far you are
	clearOpt()
	next_submit_swap()
	


func _on_option_a_pressed() -> void:
	#set current selected answer to 1
	answerSet[questionNum] = 1
	#set this sprite to different sprite
	clearOpt()
	
	#draft code for adding number to score, Correct values as we get database together - Shay
	#for now I was thinking depending on the question number each value will add up to 100 for a max score
	#if(answerSet[questionNum] == questions.answer(qID)): #placeholder, replace when quiz database complete
		#correctCount+=1
		
	#Current thoughts are that we just calculate it out at the end I feel like that would be much easier
	#as far as scoring goes so it doesn't need to recalculate whenever the player picks a different option
	#we can just make a second array that pulls the correct number every time you load a question if necessary
	
	
	
#score calculation function
func ScoreCalc() -> void:
	Global.quizscore = (correctCount/totalQuestion)*100
	


func SubmitToLeaderboard() -> void:
	pass
	#insert code to import value quizscore to database
	#leaderboard name should be linked to logged in user using global var
	# use var quizscore when submitted
	
	# it's database time
	# we're going to insert into quiz scores table the score and user id
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"
	
	# open the database so we can get stuff
	account_db.open_db()
	
	# put it on in, this is saved in the database to you the user yay
	var my_query = "INSERT INTO quiz_scores (score, ID) VALUES (" + str(Global.quizscore) + ", " + str(Global.userID) + ");"
	account_db.query(my_query)
	
	account_db.close_db()

func clearOpt() -> void:
	var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
	var select = preload("res://assets/quiz_mode/opt_selected.png")
	#resets the sprites of all options when you change questions forwards or back actually
	$aChoicebox/HBoxContainer/optionA.texture_normal = nonSelect
	$aChoicebox/HBoxContainer2/optionB.texture_normal = nonSelect
	$aChoicebox/HBoxContainer3/optionC.texture_normal = nonSelect
	$aChoicebox/HBoxContainer4/optionD.texture_normal = nonSelect
	
	if answerSet[questionNum] == 1:
		$aChoicebox/HBoxContainer/optionA.texture_normal = select
	elif answerSet[questionNum] == 2:
		$aChoicebox/HBoxContainer2/optionB.texture_normal = select
	elif answerSet[questionNum] == 3:
		$aChoicebox/HBoxContainer3/optionC.texture_normal = select
	elif answerSet[questionNum] == 4:
		$aChoicebox/HBoxContainer4/optionD.texture_normal = select


func _on_option_b_pressed() -> void:
		answerSet[questionNum] = 2
		#set this sprite to different sprite
		clearOpt()


func _on_option_c_pressed() -> void:
	answerSet[questionNum] = 3
	clearOpt()


func _on_option_d_pressed() -> void:
	answerSet[questionNum] = 4
	clearOpt()
	
func next_submit_swap() -> void:
	var next1 = preload("res://assets/quiz_mode/nextButton_1.png")
	var next2 = preload("res://assets/quiz_mode/nextButton_2.png")
	
	var submit1 = preload("res://assets/quiz_mode/submitButton_1.png")
	var submit2 = preload("res://assets/quiz_mode/submitButton_2.png")
	
	if questionNum == 19:
		$nextQ.texture_normal = submit1
		$nextQ.texture_hover = submit2
	else:
		$nextQ.texture_normal = next1
		$nextQ.texture_hover = next2

func checkAllAnswers() -> void:
	var allAns = true
	var ANSWERME = ""
	#you are legally required to submit an answer for every question now
	#step 1: LOOPS BABEY
	for i in range(0, 20):
		if answerSet[i] == 0:
			allAns = false
			ANSWERME = ANSWERME + ", " + str(i + 1)
		
	if allAns == true:
		#calculate score
		ScoreCalc()
		# put that in the database yippee BUT ONLY if you have an account
		if Global.userID != 0:
			SubmitToLeaderboard()
		# skedaddle to results page
		get_tree().change_scene_to_file("res://Results_Screen.tscn")

	else:
		# NOOOOOO YOU CAN'T DO THATTTTT
		#testing a bit here
		$missingQBox/qText.text = ANSWERME
		pass
		#I want my java forloops back
