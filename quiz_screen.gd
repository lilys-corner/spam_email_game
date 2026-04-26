extends Control
var database: SQLite
var account_db

#Is the options menu available?
var options1 = false

#Variables
var totalQuestion = 20
var correctCount = 0
var questionNum = 0
# question set full of qIDs in order, correlate with answerSet
var questionSet = [] 
#0 = no answer selected
var answerSet = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var rng = RandomNumberGenerator.new()
#asset loading for answers
var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
var select = preload("res://assets/quiz_mode/opt_selected.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$opBKG/optionsMenu/overallVolume.value = Global.masterVolume
	$opBKG/optionsMenu/musicVolume.value = Global.musicVolume
	$opBKG/optionsMenu/sfxVolume.value = Global.sfxVolume
	
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$opBKG/clickSFX.set_volume_linear(sfxVol)
	$opBKG/backSFX.set_volume_linear(sfxVol)
	
	database = SQLite.new()
	database.path = "res://questionsData.db" #would want to be using user:// for saves
	database.open_db()
	questionSet.resize(20)
	print(questionSet)

	#get numbers of each question, put IDs in array
	#initialize question ID array
	#randomize numbers and fill in array
	for i in range(0, 20):
		var temp_val = rng.randi_range(0, 39) 
		# confirmed to be 40 questions in db (for randi_range)
		
		while questionSet.has(temp_val):
			temp_val = rng.randi_range(0, 39)
		questionSet[i] = temp_val
	
	var qID = questionSet[questionNum]
	#retrieve information for first question
	var questionData = database.select_rows("questions", "qID = qID", ["*"])
	var quesBody : String = questionData[qID]["qBody"]
	var quesChoice1 : String = questionData[qID]["qChoice1"]
	var quesChoice2 : String = questionData[qID]["qChoice2"]
	var quesChoice3 : String = questionData[qID]["qChoice3"]
	var quesChoice4 : String = questionData[qID]["qChoice4"]
	
	
	#update labels
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

#Back Button Pressed to go back to previous question
func _on_prev_q_pressed() -> void:
	#check
	if questionNum == 0:
		pass
	else:
		#decrement
		questionNum = questionNum - 1
		
		#update
		updateQuestion()

#Next Button Pressed to advance to next question
func _on_next_q_pressed() -> void:
	#check
	if(questionNum == 19):
		#check if all answers are filled
		checkAllAnswers()
		#obligatory are you sure you want to submit warning
	else:
		#increment
		questionNum = questionNum + 1
		updateQuestion()

#Update the question
func updateQuestion() -> void:
	var qID = questionSet[questionNum]
	var questionData = database.select_rows("questions", "qID = qID", ["*"])
	var quesBody : String = questionData[qID]["qBody"]
	var quesChoice1 : String = questionData[qID]["qChoice1"]
	var quesChoice2 : String = questionData[qID]["qChoice2"]
	var quesChoice3 : String = questionData[qID]["qChoice3"]
	var quesChoice4 : String = questionData[qID]["qChoice4"]
	
	#update text:
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
	

#score calculation function
func ScoreCalc() -> void:
	# this is pretty temporary it's just so i can search it later
	var correct = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	for i in range(0, 20):
		# the question we are currently checking, goes from first to last
		var qID = questionSet[i] + 1
		# i don't know why i need to + 1 but if i encounter a 0 it crashes and this works
		# my sanity is gone but i live
		
		# query for the int number of the correct answer. this will be stored in database.query_result
		var my_query = "SELECT qCorrect FROM questions WHERE qID = " + str(qID)
		database.query(my_query)
		
		# now. if it matches, correctCount + 1. if not, ignore (for now)
		if (database.query_result[0]["qCorrect"] == answerSet[i]):
			correctCount += 1
			correct[i] = 1
	
	# when we are done with this for loop, we have correctCount. yayy we can calculate the score!!
	# quizscore is an int hence why i *100 and then divide, bc otherwise it's 0
	Global.quizscore = (correctCount*100)/totalQuestion
	
	#Count incorrect questions
	var incorrectCount = totalQuestion - correctCount
	
	# resize array to incorrect amount
	# cur_index is to make sure we fill in the array correctly
	Global.incorrectquiz.resize(incorrectCount)
	var cur_index = 0
	
	for i in range (0, 20):
		if (correct[i] == 0):
			# fill incorrectquiz with the IDs of the wrongly answered questions
			Global.incorrectquiz[cur_index] = questionSet[i] + 1
			cur_index += 1
	# now we should have a global array filled with qIDs
	
	print(Global.incorrectquiz)

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
	# Load in asset
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

# Selecting Answers
func _on_option_b_pressed() -> void:
		answerSet[questionNum] = 2
		clearOpt()


func _on_option_c_pressed() -> void:
	answerSet[questionNum] = 3
	clearOpt()


func _on_option_d_pressed() -> void:
	answerSet[questionNum] = 4
	clearOpt()
	
#Switch Next Button Asset to Submit
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

#Check if all questions were answered
func checkAllAnswers() -> void:
	var allAns = true
	var ANSWERME = ""
	#step 1: LOOPS BABEY
	for i in range(0, 20):
		if answerSet[i] == 0:
			allAns = false
			if (i == 0):
				ANSWERME = ANSWERME + str(i + 1)
			else:
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
		$missingQBox/qText.text = ANSWERME
		#bring the text box over here, gang
		var position = Vector2(960.0, 500.0)
		#yoink
		$missingQBox.global_position = position

func _on_texture_button_pressed() -> void:
	var position = Vector2(-400, -400)
	$missingQBox.global_position = position

func _input(event):
	var optionsPosition = Vector2(0.0, 0.0)
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if options1 == false:
				optionsPosition = Vector2(960.0, 500.0)
				options1 = true
			else:
				optionsPosition = Vector2(960.0, -600.0)
				options1 = false
			#replace with the options menu
			
			$opBKG.global_position = optionsPosition

#Close already option menu
func _on_exit_menu_pressed() -> void:
	options1 = false
	$opBKG.global_position = Vector2(960.0, -600.0)
	#Closes the options menu

func _on_save_opt_pressed() -> void:
	#save settings to the global variables
	Global.masterVolume = $opBKG/optionsMenu/overallVolume.value
	Global.musicVolume = $opBKG/optionsMenu/musicVolume.value
	Global.sfxVolume = $opBKG/optionsMenu/sfxVolume.value
	
	#recalculating the volume
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$opBKG/clickSFX.set_volume_linear(sfxVol)
	$opBKG/backSFX.set_volume_linear(sfxVol)

#Reset Volume Settings to last saved state
func _on_cancel_opt_pressed() -> void:
	$opBKG/optionsMenu/overallVolume.value = Global.masterVolume
	$opBKG/optionsMenu/musicVolume.value = Global.musicVolume
	$opBKG/optionsMenu/sfxVolume.value = Global.sfxVolume

#Exit to Main Menu
func _on_quit_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

func _on_menu_button_pressed() -> void:
	var optionsPosition = Vector2(0.0, 0.0)
	optionsPosition = Vector2(960.0, 500.0)
	options1 = true
	$opBKG.global_position = optionsPosition

# Large Text Toggle
func _on_large_text_toggled(toggled_on: bool) -> void:
	$opBKG/clickSFX.play()
	var settings_theme = preload("res://settings_theme.tres")
	var quiz_theme = preload("res://quiz_theme.tres")
	var score_values_theme = preload("res://scoreboard_rank_theme.tres")
	var results_label_theme = preload("res://results_label_theme.tres")
	var results_text_theme = preload("res://results_text_theme.tres")
	
	if(toggled_on == true):
		settings_theme.set_font_size("font_size", "Label", 34)
		settings_theme.set_font_size("font_size", "CheckButton", 34)
		quiz_theme.set_font_size("normal_font_size", "RichTextLabel", 35)
		score_values_theme.set_font_size("font_size", "Label", 36)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 50)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 38)
	
	else:
		settings_theme.set_font_size("font_size", "Label", 24)
		settings_theme.set_font_size("font_size", "CheckButton", 24)
		quiz_theme.set_font_size("normal_font_size", "RichTextLabel", 28)
		score_values_theme.set_font_size("font_size", "Label", 26)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 40)
		results_text_theme.set_font_size("normal_font_size", "RichTextLabel", 28)
