extends Control

#Is the options menu up?
var options1 = false

# Executes when the scene is opened
func _ready() -> void:
	# Set volume
	$opBKG/optionsMenu/overallVolume.value = Global.masterVolume
	$opBKG/optionsMenu/musicVolume.value = Global.musicVolume
	$opBKG/optionsMenu/sfxVolume.value = Global.sfxVolume

	#set the actual volumes of the back and click sfx
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$opBKG/clickSFX.set_volume_linear(sfxVol)
	$opBKG/backSFX.set_volume_linear(sfxVol)
	
	# rest of _ready is for the game
	# other quiz stuff is way below
	database = SQLite.new()
	database.path = "res://questionsData.db"
	database.open_db()
	emailSet.resize(20)

	#get numbers of each question, put IDs in array
	#initialize question ID array
	#randomize numbers and fill in array
	for i in range(0, 20):
		var temp_val = rng.randi_range(0, 34)
		print("Before reroll", temp_val)
		
		while emailSet.has(temp_val):
			temp_val = rng.randi_range(0, 34)
		emailSet[i] = temp_val
	
	# Email ID to retrieve information from
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
	
	# Set the email number at the top right to the current email
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
	# If the user clicks escape, the options will appear or disappear
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

# Close the menu with the X button as an alternative to ESC
func _on_exit_menu_pressed() -> void:
	options1 = false
	$opBKG.global_position = Vector2(960.0, -600.0)

# Save the volume settings
func _on_save_opt_pressed() -> void:
	Global.masterVolume = $opBKG/optionsMenu/overallVolume.value
	Global.musicVolume = $opBKG/optionsMenu/musicVolume.value
	Global.sfxVolume = $opBKG/optionsMenu/sfxVolume.value
	
	#recalculating the volume
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$opBKG/clickSFX.set_volume_linear(sfxVol)
	$opBKG/backSFX.set_volume_linear(sfxVol)

# Reset the volume settings to before the changes
func _on_cancel_opt_pressed() -> void:
	$opBKG/optionsMenu/overallVolume.value = Global.masterVolume
	$opBKG/optionsMenu/musicVolume.value = Global.musicVolume
	$opBKG/optionsMenu/sfxVolume.value = Global.sfxVolume

# Quit the game upon clicking Quit Game
func _on_quit_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

# Open the settings as an alternative to ESC
func _on_menu_button_pressed() -> void:
	var optionsPosition = Vector2(0.0, 0.0)
	optionsPosition = Vector2(960.0, 500.0)
	options1 = true
	$opBKG.global_position = optionsPosition

# Game from here and below
# Declare both databases questionsData.db and accounts.db
var database: SQLite
var account_db

# total email count
var totalEmail = 20

# correct answers (changed during calculation)
var correctCount = 0

# current email
var emailNum = 0

# Set of randomized emails
var emailSet = []

# Answers chosen for each email
var answerSet = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

var rng = RandomNumberGenerator.new()

var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
var select = preload("res://assets/quiz_mode/opt_selected.png")

# BACK button
func _on_prev_e_pressed() -> void:
	# Check if you are on the first question
	if emailNum == 0:
		pass
		# You cannot go back if you are on the first question
	else:
		# Go back a question and update the email information to reflect the previous question
		emailNum = emailNum - 1
		updateEmail()

# NEXT button
func _on_next_e_pressed() -> void:
	# Check if you are on the last question
	if(emailNum == 19):
		# The texture is currently the SUBMIT button as per next_submit_swap()
		# Are all answers filled?
		checkAllAnswers()
	else:
		# Go forward a question and update the email information to reflect the next question
		emailNum = emailNum + 1
		updateEmail()

# Update the email text boxes when you change the question
func updateEmail() -> void:
	# Retrieve all fields from the email ID in the emails table of questionsData.db
	var emailID = emailSet[emailNum] + 1
	
	var my_query = "SELECT * FROM emails WHERE emailID = " + str(emailID) + ";"
	database.query(my_query)
	
	var emailFrom : String = database.query_result[0]["emailAddress"]
	var emailSubj : String = database.query_result[0]["emailSubject"]
	var emailBody : String = database.query_result[0]["emailBody"]
	
	# Update email labels
	$emailFrom.text = "From: " + emailFrom
	$emailSubj.text = "Subject: " + emailSubj
	$emailBody.text = emailBody
	
	# Update email number
	var tempnum = emailNum + 1
	$emailCount.text = "Email " + str(tempnum) + "/20"
	
	# Ensure that multiple choice bubbles reflect the chosen answer for this email (if any)
	clearOpt()
	
	# Check if the NEXT button needs to be swapped for the SUBMIT button
	next_submit_swap()

# If the first multiple choice answer is selected
func _on_option_a_pressed() -> void:
	# Set the current selected answer to 1
	answerSet[emailNum] = 1
	
	# Reflect this answer in the sprites
	clearOpt()

# If the first multiple choice answer is selected
func _on_option_b_pressed() -> void:
	# Set the current selected answer to 2
	answerSet[emailNum] = 2
	
	# Reflect this answer in the sprites
	clearOpt()

# Score calculation
func ScoreCalc() -> void:
	# Array for whether or not the answers are correct
	var correct = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	# Check the correctness of each answer
	for i in range(0, 20):
		# The ID of the email we are currently checking, goes from first to last
		var emailID = emailSet[i] + 1
		
		# Query for the the correct answer
		var my_query = "SELECT emailAnswer FROM emails WHERE emailID = " + str(emailID)
		database.query(my_query)
		
		# Change the correct array and the number of correct answers based on correctness
		# Is yes chosen and is yes correct?
		if (database.query_result[0]["emailAnswer"] == 1 && answerSet[i] == 1):
			correctCount += 1
			correct[i] = 1
		# Is no chosen and is no correct?
		elif (database.query_result[0]["emailAnswer"] == 0 && answerSet[i] == 2):
			correctCount += 1
			correct[i] = 1
	
	# Calculate the score
	Global.gamescore = (correctCount*100)/totalEmail
	
	# Create an array for incorrect emails for the result screen
	var incorrectCount = totalEmail - correctCount
	Global.incorrectgame.resize(incorrectCount)
	var cur_index = 0
	
	# Fill array with incorrectly identified emails
	for i in range (0, 20):
		if (correct[i] == 0):
			# Fill incorrectEmail with the IDs of the wrongly identified emails
			Global.incorrectgame[cur_index] = emailSet[i] + 1
			cur_index += 1

func SubmitToLeaderboard() -> void:
	# Insert into game scores table the score and user id
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"
	
	account_db.open_db()
	
	# Insert the game score correlating to the current user into the database
	var my_query = "INSERT INTO game_scores (score, ID) VALUES (" + str(Global.gamescore) + ", " + str(Global.userID) + ");"
	account_db.query(my_query)
	
	account_db.close_db()

# Sprites reflect chosen answers
func clearOpt() -> void:
	var nonSelect = preload("res://assets/quiz_mode/opt_unselect.png")
	var select = preload("res://assets/quiz_mode/opt_selected.png")
	#resets the sprites of all options when you change questions forwards or back
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
			if (i == 0):
				ANSWERME = ANSWERME + str(i + 1)
			else:
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
