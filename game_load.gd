extends Control
var database: SQLite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "THIS IS SUPPOSED TO BE A LOADING SCREEN HIT CONTINUE"
	#Load in anything that we need
	#This is the page with your load game, new game, etc data
	database = SQLite.new()
	database.path = "res://questionsData.db" #would want to be using user:// for saves
	database.open_db()
	#insert_question()
	#insert_good_email()
	select_data()
	
	
	
	#DIFFERENT FUNCTIONS FOR DATABASES
	#create_table()
	#insert_data()
	#select_data()
	#update_data()
	#delete_data()
	#and then we have the go to next page function actually
	#Basically: load in things
	#then immediately swap to next page
	# IF YOU BASICALLY DON'T SEE THIS PAGE IT IS WORKING AS INTENDED
	get_tree().change_scene_to_file("res://Login_Screen.tscn")

func create_table() -> void:
	var table:Dictionary = {
		"id":{
			"data_type": "int",
			"primary_key": true,
			"not_null": true,
			"auto_increment": true
		},
		"player_name":{
			"data_type": "text"},
		"save_point":{
			"data_type": "int"
		}
		}
	database.create_table("players", table)

func insert_data() -> void:
	var data: Dictionary = {
		"player_name": "JohnDoe"
	}
	database.insert_row("players", data)

#func select_data() -> void:
	#print(database.select_rows("players", "xp > 0", ["*"]))

func update_data() -> void:
	database.update_rows("players", "player_name = 'JohnDoe'",{"save_point": 4})

func delete_data() -> void:
	database.delete_rows("players", "player_name = 'NAME'")

func select_data() -> void:
	#print(database.select_rows ("questions", "qID = 1", ["*"]))
	var q1Data = database.select_rows ("questions", "qID = 1", ["*"])
	print(q1Data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tempnext_pressed() -> void:
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
	
	
#func create_question_table() -> void:
	#var table:Dictionary = {
		#"malEmailID":{
			#"data_type": "int",
			#"primary_key": true,
			#"not_null": true,
			#"auto_increment": true
		#},
		#"malEmailAddress":{
			#"data_type": "char(254)"},
		#"malEmailSubject":{
			#"data_type": "char(1000)"},
		#"malEmailBody": {
			#"data_type": "text"
		#},
		#"malEmailReportNum": {
			#"data_type": "int"
		#}
	#}
	#database.create_table("mal_emails", table)

func insert_question() -> void:
	var data: Dictionary = {
		"qBody": 'How can you verify the legitimacy of a phishing email from a company you do business with?',
		"qChoice1": 'Trust the email and respond with the requested information.',
		"qChoice2": 'Click on any links in the email to follow the instructions.'
		,"qChoice3": 'Contact the company directly using the contact details from their official website and ask if they sent the email.',
		"qChoice4": 'Reply to the email with your personal details to resolve the issue.',
		"qCorrect": 3

	}	
	database.insert_row("questions", data)
	
func insert_good_email() -> void:
	var data: Dictionary = {
		"emailAddress": "venmo@email.venmo.com",
		"emailSubject": "John, here's $5",
		"emailBody": "Venmo
$5 from us to you!
Come back to Venmo and cash in with $5. Just use the button below to log in, and we'll
drop the money into your Venmo account automatically.
Don't wait - this offer is only good for two weeks!"
	}
	database.insert_row("emails", data)
