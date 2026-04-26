extends Control

#Is the options menu available?
var options1 = false

func _ready() -> void:
	$opBKG/optionsMenu/overallVolume.value = Global.masterVolume
	$opBKG/optionsMenu/musicVolume.value = Global.musicVolume
	$opBKG/optionsMenu/sfxVolume.value = Global.sfxVolume

	#set the actual volumes of the back and click sfx
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$opBKG/clickSFX.set_volume_linear(sfxVol)
	$opBKG/backSFX.set_volume_linear(sfxVol)
	
	# ^ pop up menu
	# rest of _ready is for the game
	# other quiz stuff is way below
	database = SQLite.new()
	database.path = "res://questionsData.db" #would want to be using user:// for saves
	database.open_db()
	emailSet.resize(20)

	#get numbers of each question, put IDs in array
	#initialize question ID array
	#randomize numbers and fill in array
	for i in range(0, 20):
		var temp_val = rng.randi_range(0, 34) #not a clue how many entries we will have
		print("Before reroll", temp_val)
		# confirmed to be 40 questions in db (for randi_range)
		
		while emailSet.has(temp_val):
			temp_val = rng.randi_range(0, 34)
		emailSet[i] = temp_val
	
	var emailID = emailSet[emailNum] + 1
	#retrieve information for first question
	var my_query = "SELECT * FROM emails WHERE emailID = " + str(emailID) + ";"
	database.query(my_query)
	var emailFrom : String = database.query_result[0]["emailAddress"]
	var emailSubj : String = database.query_result[0]["emailSubject"]
	var emailBody : String = database.query_result[0]["emailBody"]
	
	# update labels
	$emailFrom.text = "From: " + emailFrom
	$emailSubj.text = "Subject: " + emailSubj
	$emailBody.text = emailBody
	
	var tempnum = emailNum + 1
	$emailCount.text = "Email " + str(tempnum) + "/20"

func _process(delta: float) -> void:
	pass

# OPTIONS
# X button at the top to close it, Settings: fullscreen
# Overall sound, Music vol, SFX vol, big text toggle
# Saving off the settings, Quit game
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

#Close already open menu
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

func _on_cancel_opt_pressed() -> void:
	$opBKG/optionsMenu/overallVolume.value = Global.masterVolume
	$opBKG/optionsMenu/musicVolume.value = Global.musicVolume
	$opBKG/optionsMenu/sfxVolume.value = Global.sfxVolume

func _on_quit_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

# here we go... all this is like basically quiz_screen.gd
var database: SQLite
var account_db

var totalEmail = 20
var correctCount = 0
var emailNum = 0
var emailSet = []
var answerSet = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

var rng = RandomNumberGenerator.new()

var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
var select = preload("res://assets/quiz_mode/opt_selected.png")

func _on_return_to_menutemp_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

# from here on is quiz
func _on_prev_e_pressed() -> void:
	#check
	if emailNum == 0:
		pass
		#do nothing. you can't go back. unless we want you to be able to quit out of the quiz.
	else:
		#decrement
		emailNum = emailNum - 1
		
		#update
		updateEmail()

func _on_next_e_pressed() -> void:
	#check
	if(emailNum == 19):
		#texture is submit button
		
		#check if all answers are filled
		checkAllAnswers()
		#obligatory are you sure you want to submit warning
	else:
		#increment
		emailNum = emailNum + 1
		updateEmail()
	#update

func updateEmail() -> void:
	var emailID = emailSet[emailNum] + 1
	
	var my_query = "SELECT * FROM emails WHERE emailID = " + str(emailID) + ";"
	database.query(my_query)
	
	var emailFrom : String = database.query_result[0]["emailAddress"]
	var emailSubj : String = database.query_result[0]["emailSubject"]
	var emailBody : String = database.query_result[0]["emailBody"]
	
	# update labels
	$emailFrom.text = "From: " + emailFrom
	$emailSubj.text = "Subject: " + emailSubj
	$emailBody.text = emailBody
	
	var tempnum = emailNum + 1
	$emailCount.text = "Email " + str(tempnum) + "/20"

	clearOpt()
	next_submit_swap()

func _on_option_a_pressed() -> void:
	#set current selected answer to 1
	answerSet[emailNum] = 1
	#set this sprite to different sprite
	clearOpt()

func _on_option_b_pressed() -> void:
		answerSet[emailNum] = 2
		#set this sprite to different sprite
		clearOpt()

#score calculation function
func ScoreCalc() -> void:
	# for searching later
	var correct = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	# same deal as quiz, get correctCount, make incorrect array yay
	
	for i in range(0, 20):
		# the question we are currently checking, goes from first to last
		var emailID = emailSet[i] + 1
		
		# query for the int number of the correct answer. this will be stored in database.query_result
		var my_query = "SELECT emailAnswer FROM emails WHERE emailID = " + str(emailID)
		database.query(my_query)
		
		# now. if it matches, correctCount + 1. if not, ignore (for now)
		# answers are 1 for yes, 2 for no, emailAnswer is 0 for no, 1 for yes
		# are both the answer and the data Yes?
		if (database.query_result[0]["emailAnswer"] == 1 && answerSet[i] == 1):
			correctCount += 1
			correct[i] = 1
		# are they both No?
		elif (database.query_result[0]["emailAnswer"] == 0 && answerSet[i] == 2):
			correctCount += 1
			correct[i] = 1
	
	# when we are done with this for loop, we have correctCount. yayy we can calculate the score!!
	# quizscore is an int hence why i *100 and then divide, bc otherwise it's 0
	Global.gamescore = (correctCount*100)/totalEmail
	
	# OKAY. so we have the number of correct questions.
	# get incorrectCount for our incorrect array!
	var incorrectCount = totalEmail - correctCount
	
	# resize array to incorrect amount
	# cur_index is to make sure we fill in the array correctly
	Global.incorrectgame.resize(incorrectCount)
	var cur_index = 0
	
	for i in range (0, 20):
		if (correct[i] == 0):
			# fill incorrectquiz with the IDs of the wrongly answered questions
			Global.incorrectgame[cur_index] = emailSet[i] + 1
			cur_index += 1
	# now we should have a global array filled with qIDs

func SubmitToLeaderboard() -> void:
	# insert into game scores table the score and user id
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"
	
	account_db.open_db()
	
	# query to insert data
	var my_query = "INSERT INTO game_scores (score, ID) VALUES (" + str(Global.gamescore) + ", " + str(Global.userID) + ");"
	account_db.query(my_query)
	
	account_db.close_db()

func clearOpt() -> void:
	var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
	var select = preload("res://assets/quiz_mode/opt_selected.png")
	#resets the sprites of all options when you change questions forwards or back actually
	$aChoicebox/HBoxContainer/optionA.texture_normal = nonSelect
	$aChoicebox/HBoxContainer2/optionB.texture_normal = nonSelect
	
	if answerSet[emailNum] == 1:
		$aChoicebox/HBoxContainer/optionA.texture_normal = select
	elif answerSet[emailNum] == 2:
		$aChoicebox/HBoxContainer2/optionB.texture_normal = select

func next_submit_swap() -> void:
	#Load in assets
	var next1 = preload("res://assets/quiz_mode/nextButton_1.png")
	var next2 = preload("res://assets/quiz_mode/nextButton_2.png")
	var submit1 = preload("res://assets/quiz_mode/submitButton_1.png")
	var submit2 = preload("res://assets/quiz_mode/submitButton_2.png")
	
	if emailNum == 19:
		$nextE.texture_normal = submit1
		$nextE.texture_hover = submit2
	else:
		$nextE.texture_normal = next1
		$nextE.texture_hover = next2

#Check if all questions have been answered
func checkAllAnswers() -> void:
	var allAns = true
	var ANSWERME = ""
	
	# check what hasn't been answered
	for i in range(0, 20):
		if answerSet[i] == 0:
			allAns = false
			ANSWERME = ANSWERME + ", " + str(i + 1)
		
	if allAns == true:
		#calculate score
		ScoreCalc()
		
		# if not guest, store score
		if Global.userID != 0:
			SubmitToLeaderboard()
		# go to results page
		get_tree().change_scene_to_file("res://GResults_Screen.tscn")
	
	else:
		# you haven't answered everything
		$missingQBox/qText.text = ANSWERME
		#bring the text box over here, gang
		var position = Vector2(960.0, 500.0)
		
		$missingQBox.global_position = position

#Close Popup 
func _on_close_button_pressed() -> void:
	var position = Vector2(-400, -400)
	$missingQBox.global_position = position

func _on_menu_button_pressed() -> void:
	var optionsPosition = Vector2(0.0, 0.0)
	optionsPosition = Vector2(960.0, 500.0)
	options1 = true
	$opBKG.global_position = optionsPosition

#Resize Text to be larger
func _on_large_text_toggled(toggled_on: bool) -> void:
	$opBKG/clickSFX.play()
	var settings_theme = preload("res://settings_theme.tres")
	var quiz_theme = preload("res://quiz_theme.tres")
	var score_values_theme = preload("res://scoreboard_rank_theme.tres")
	var results_label_theme = preload("res://results_label_theme.tres")
	var results_text_theme = preload("res://results_text_theme.tres")
	var game_theme = preload("res://game_theme.tres")
	
	if(toggled_on == true):
		settings_theme.set_font_size("font_size", "Label", 34)
		settings_theme.set_font_size("font_size", "CheckButton", 34)
		quiz_theme.set_font_size("normal_font_size", "RichTextLabel", 35)
		score_values_theme.set_font_size("font_size", "Label", 36)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 50)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 38)
		game_theme.set_font_size("normal_font_size", "RichTextLabel", 38)
	
	else:
		settings_theme.set_font_size("font_size", "Label", 24)
		settings_theme.set_font_size("font_size", "CheckButton", 24)
		quiz_theme.set_font_size("normal_font_size", "RichTextLabel", 28)
		score_values_theme.set_font_size("font_size", "Label", 26)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 40)
		results_text_theme.set_font_size("normal_font_size", "RichTextLabel", 28)
		game_theme.set_font_size("normal_font_size", "RichTextLabel", 28)
