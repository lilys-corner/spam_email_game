extends Control
var account_db

func _ready() -> void:
	# Open account database
	account_db = SQLite.new()
	account_db.path = "res://accounts.db"

func _process(delta: float) -> void:
	pass

func _on_submit_button_pressed() -> void:
	# Get the username
	var Username = $EnterUsername.text
	
	# Get the password
	var Password = $EnterPassword.text
	
	# Is there a username?
	if not Username:
		$ErrorLabel.text = "Enter a username."
		return
	
	# Is there a password?
	if not Password:
		$ErrorLabel.text = "Enter a password."
		return
	
	# Select first word of username and password to prevent SQL errors
	Username = Username.split(" ")
	Username = Username[0]
	
	Password = Password.split(" ")
	Password = Password[0]
	
	# Ensure username and password are 20 char or less
	if Username.length() > 20:
		$ErrorLabel.text = "Username must be 20 characters or less."
		return
	
	if Password.length() > 20:
		$ErrorLabel.text = "Password must be 20 characters or less."
		return
	
	account_db.open_db()
	
	# Open all usernames from the database
	account_db.query("SELECT username FROM accounts;")
	var user_match = 0
	
	# Check all usernames for a matching one (case matters)
	for i in range (0, account_db.query_result.size()):
		if Username == account_db.query_result[i]["username"]:
			user_match = 1
	
	# Username cannot be saved as the username is already taken
	if user_match == 1:
		$ErrorLabel.text = "Username is taken."
		account_db.close_db()
		return
	
	# Otherwise, the username is not taken and this will be saved to the DB
	# Encrypt the password
	Password = Password.sha256_text()
	
	# Save the username nad password
	var this_query = "INSERT INTO accounts ('username', 'password') values ('" + Username + "', '" + Password + "');"
	account_db.query(this_query)
	
	account_db.close_db()
	
	# Go back to the login screeen
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
 
# Return to login without doing anything
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
