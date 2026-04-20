extends Control
var account_db

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# go forth my beautiful database
	# making a new instance of "SQLite" using the accounts.db database
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"
	
	#We are going to need to make the text boxes visible soon
	#Remind me to do that. I can make them okay later.
	#I just have to make it exist first
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_submit_button_pressed() -> void:
	#on submit button down should allow for mouse
	#click functionality? I was looking at tutorials and
	#that should work I hope?
	
	#wow! It's a submit button
	#when you click this, you submit the text in the EnterUsername
	#and EnterPassword boxes
	#and then it gets compared to the data in the database
	#and accepts if the username and password match and gives the user a warning if they don't
	#think like "Username or password is incorrect"
	
	var Username = $EnterUsername.text
	var Password = $EnterPassword.text
	#maybe we should look into using an encryption for the password?
	#Godot has something like $EnterPassword.text.sha256_text()
	
	# is there a username?
	if not Username:
		$ErrorLabel.text = "Enter a username."
		return
	
	# is there a password?
	if not Password:
		$ErrorLabel.text = "Enter a password."
		return
	
	# if you're here, you have both a username and password. let's check it
	# open up the database so we have access
	account_db.open_db()
	
	# this asks for all the usernames we currently have
	account_db.query("SELECT username FROM accounts;")
	var user_match = 0
	
	# the result of a query will save in the query_result method
	# is the entered username a valid username? if not, say it don't exist
	for i in range (0, account_db.query_result.size()):
		if Username == account_db.query_result[i]["username"]:
			user_match = 1
	
	if user_match == 0:
		print(Username)
		print(account_db.query_result)
		$ErrorLabel.text = "Username is invalid."
		account_db.close_db()
		return
	
	# omg yay. this means that the username is right
	# asks for encrypted passwords we got. so gibberish basically
	account_db.query("SELECT password FROM accounts;")
	var pass_match = 0
	
	# check if password (encrypted to also be gibberish) is valid
	for i in range (0, account_db.query_result.size()):
		if Password.sha256_text() == account_db.query_result[i]["password"]:
			pass_match = 1
	
	if pass_match == 0:
		$ErrorLabel.text = "Password is invalid."
		account_db.close_db()
		return
		
	else:
		# get the user id
		var user_query = "SELECT id FROM accounts WHERE username = " + Username
		account_db.query(user_query)
		Global.userID = account_db.query_results
		
		account_db.close_db()
		
		# yay go to game
		get_tree().change_scene_to_file("res://Main_Menu.tscn")

#Honestly I'm not entirely sure what I'm doing here
#The point is that I want it so that you can submit the username
#And password with the submit button
#And not have to hit enter for the two individual username and password boxes seperately
#Unfortunately I have not a single clue how to go about doing that
 
func _on_enter_username_text_submitted(new_text: String) -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
