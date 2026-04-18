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
	# same as log_in with minor changes
	# i literally just copy pasted log_in.gd
	
	# get username and get the first word
	var Username = $EnterUsername.text
	
	# get password and get the first word
	var Password = $EnterPassword.text
	
	# is there a username?
	if not Username:
		$ErrorLabel.text = "Enter a username."
		return
	
	# is there a password?
	if not Password:
		$ErrorLabel.text = "Enter a password."
		return
	
	# splitting it turns it into packed array for some reason ew
	# fix that by setting it to the first value before the space
	Username = Username.split(" ")
	Username = Username[0]
	
	Password = Password.split(" ")
	Password = Password[0]
	
	if Username.length() > 20:
		$ErrorLabel.text = "Username must be 20 characters or less."
		return
	
	if Password.length() > 20:
		$ErrorLabel.text = "Password must be 20 characters or less."
		return
	
	# if you're here, you have both a username and password. let's check it
	# both are <20 char and one word
	# open up the database so we have access
	account_db.open_db()
	
	# this asks for all the usernames we currently have
	# to see if this username repeats
	account_db.query("SELECT username FROM accounts;")
	var user_match = 0
	
	# the result of a query will save in the query_result method
	# is the entered username a valid username? if not, say it don't exist
	for i in range (0, account_db.query_result.size()):
		if Username == account_db.query_result[i]["username"]:
			user_match = 1
	
	if user_match == 1:
		$ErrorLabel.text = "Username is taken."
		account_db.close_db()
		return
	
	# omg yay. this means that the username is new
	# set the username and (encrypted) password into the database
	Password = Password.sha256_text()
	var this_query = "INSERT INTO accounts ('username', 'password') values ('" + Username + "', '" + Password + "');"
	account_db.query(this_query)
	
	account_db.close_db()
	# yay go to login
	get_tree().change_scene_to_file("res://Login_Screen.tscn")

#Honestly I'm not entirely sure what I'm doing here
#The point is that I want it so that you can submit the username
#And password with the submit button
#And not have to hit enter for the two individual username and password boxes seperately
#Unfortunately I have not a single clue how to go about doing that
 
func _on_enter_username_text_submitted(new_text: String) -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
