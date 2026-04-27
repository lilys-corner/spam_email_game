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
	# Set volume
	$opBKG/optionsMenu/overallVolume.value = Global.masterVolume
	$opBKG/optionsMenu/musicVolume.value = Global.musicVolume
	$opBKG/optionsMenu/sfxVolume.value = Global.sfxVolume
	
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$opBKG/clickSFX.set_volume_linear(sfxVol)
	$opBKG/backSFX.set_volume_linear(sfxVol)
	
	# Open questionsData for question data
	database = SQLite.new()
	database.path = "res://questionsData.db"
	database.open_db()
	questionSet.resize(20) # 20 questions

	# Fill array questionSet with questions
	for i in range(0, 20):
		var temp_val = rng.randi_range(0, 39) 
		
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
	
	# Reflect current question number
	var tempnum = questionNum + 1
	$questionCount.text = "Question " + str(tempnum) + "/20"

func _process(delta: float) -> void:
	pass

#Back Button Pressed to go back to previous question
func _on_prev_q_pressed() -> void:
	if questionNum == 0:
		pass
		# No going back on first question
	else:
		# Go to previous question
		questionNum = questionNum - 1
		updateQuestion()

#Next Button Pressed to advance to next question
func _on_next_q_pressed() -> void:
	if(questionNum == 19):
		# Submit button, check if all questions are answered
		checkAllAnswers()
	else:
		# Go to next question
		questionNum = questionNum + 1
		updateQuestion()

#Update the question
func updateQuestion() -> void:
	# Retrieve question data
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
	
	# Update question number
	var tempnum = questionNum + 1
	$questionCount.text = "Question " + str(tempnum) + "/20"
	
	# Reflect current answers
	clearOpt()
	
	# Change to submit texture if on last question
	next_submit_swap()

# Select option 1
func _on_option_a_pressed() -> void:
	#set current selected answer to 1
	answerSet[questionNum] = 1
	#set this sprite to different sprite
	clearOpt()

#score calculation function
func ScoreCalc() -> void:
	# To search correct answers
	var correct = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	for i in range(0, 20):
		# the question we are currently checking, goes from first to last
		var qID = questionSet[i] + 1
		
		# query for the int number of the correct answer. this will be stored in database.query_result
		var my_query = "SELECT qCorrect FROM questions WHERE qID = " + str(qID)
		database.query(my_query)
		
		# If it matches, correctCount + 1, correct array is 1 there
		if (database.query_result[0]["qCorrect"] == answerSet[i]):
			correctCount += 1
			correct[i] = 1
	
	# Calculate score
	Global.quizscore = (correctCount*100)/totalQuestion
	
	# Count incorrect questions to resize incorrect array
	var incorrectCount = totalQuestion - correctCount
	Global.incorrectquiz.resize(incorrectCount)
	var cur_index = 0
	
	# Fill array with IDs of incorrectly answered questions
	for i in range (0, 20):
		if (correct[i] == 0):
			Global.incorrectquiz[cur_index] = questionSet[i] + 1
			cur_index += 1

func SubmitToLeaderboard() -> void:
	# Open account db
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"
	account_db.open_db()
	
	# Enter quiz score to the user in the database
	var my_query = "INSERT INTO quiz_scores (score, ID) VALUES (" + str(Global.quizscore) + ", " + str(Global.userID) + ");"
	account_db.query(my_query)
	
	account_db.close_db()

# Reflect chosen answer (if any) in texture
func clearOpt() -> void:
	# Load in asset
	var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
	var select = preload("res://assets/quiz_mode/opt_selected.png")
	
	#resets the sprites of all options when you change questions forwards or back
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

# Selecting answers other than the first
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
	
	# If any questions are not answered (0 in answerSet), you cannot submit
	for i in range(0, 20):
		if answerSet[i] == 0:
			allAns = false
			if (i == 0):
				ANSWERME = ANSWERME + str(i + 1)
			else:
				ANSWERME = ANSWERME + ", " + str(i + 1)
	
	# If all are answered:
	if allAns == true:
		# Calculate score
		ScoreCalc()
		
		# Submit to leaderboard if you are logged in
		if Global.userID != 0:
			SubmitToLeaderboard()
		
		# Continue to results
		get_tree().change_scene_to_file("res://Results_Screen.tscn")
	
	# You have not answered all questions. Popup
	else:
		$missingQBox/qText.text = ANSWERME
		var position = Vector2(960.0, 500.0)
		$missingQBox.global_position = position

# Exit button of popup, closes popup
func _on_texture_button_pressed() -> void:
	var position = Vector2(-400, -400)
	$missingQBox.global_position = position

# Open settings with ESC
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

# Saves volume
func _on_save_opt_pressed() -> void:
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

# Alternative to opening menu with ESC
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
