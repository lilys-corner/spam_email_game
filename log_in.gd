extends Control
var account_db

func _ready() -> void:
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"

func _process(delta: float) -> void:
	pass

func _on_submit_button_pressed() -> void:
	# Receive username and password
	var Username = $EnterUsername.text
	var Password = $EnterPassword.text
	
	# is there a username?
	if not Username:
		$ErrorLabel.text = "Enter a username."
		return
	
	# is there a password?
	if not Password:
		$ErrorLabel.text = "Enter a password."
		return
	
	account_db.open_db()
	
	# Pull all usernames from the table
	account_db.query("SELECT ID, username FROM accounts;")
	var user_match = 0
	
	# Does the username match any in the database?
	for i in range (0, account_db.query_result.size()):
		if Username == account_db.query_result[i]["username"]:
			user_match = 1
			# if it matches, make sure that the global user id is that
			Global.userID = account_db.query_result[i]["ID"]
	
	# The username doesn't match
	if user_match == 0:
		$ErrorLabel.text = "Username is invalid."
		account_db.close_db()
		return
	
	# If you're here, the username is in the database. Retrieve the password
	var my_query = "SELECT password FROM accounts WHERE ID = " + str(Global.userID)
	account_db.query(my_query)
	var pass_match = 0
	
	# Is the password entered matching that of the username?
	if Password.sha256_text() == account_db.query_result[0]["password"]:
		pass_match = 1
	
	# If it doesn't match, password is not valid
	if pass_match == 0:
		$ErrorLabel.text = "Password is invalid."
		account_db.close_db()
		return
	
	# Username and password are valid, log in
	else:
		account_db.close_db()
		
		# Continue to game
		get_tree().change_scene_to_file("res://Main_Menu.tscn")

# Return to login screen without doing anything
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
