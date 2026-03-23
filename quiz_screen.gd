extends Control

#ok so you gotta put your variables up here so the program doesn't
#scream at you
var questionNum = 0
var questionSet = []
var answerSet = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
#assuming I can count that is 20 0s. if we change the number of questions we will have to change that too
#0: no answer selected
#we will want the submit button to check and see if there are any 0s left
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#get numbers of each question, put IDs in array
	#initialize question ID array
	#randomize numbers and fill in array
	for i in range(0, 19):
		#determine spam or not spam
		#get random number
		questionSet[i] = rng.randi_range(1, 1) #not a clue how many entries we will have
		#put in array
		#if it needs to be more specific, make it more specific
	
	#default. you. you messed something up if you see this.
	$emailAddress.text = "REPLACE LATER. EMAIL ADDRESS."
	$emailSubject.text = "REPLACE LATER. SUBJECT."
	$emailBody.text = "REPLACE LATER. EMAIL BODY. ACCORDING TO ALL KNOWN LAWS OF AVIATION THERE IS NO WAY THAT A BEE SHOULD BE ABLE TO FLY. ITS WINGS ARE TOO SMALL TO GET ITS FAT LITTLE BODY OFF THE GROUND. THE BEE OF COURSE, FLIES ANYWAYS. BECAUSE BEES DON'T CARE WHAT HUMANS THINK IS IMPOSSIBLE."
	#^ long text to show that it is a big text box
	#question, options
	$questionItself.text = "QUESTION HERE"
	$answer1.text = "AAAAA"
	$answer2.text = "BBBBB"
	$answer3.text = "C"
	$answer4.text = "DEFGHIJKLMNOP"
	

	#retrieve information for first question
	
	
	#update labels


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_to_menutemp_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")


func _on_prev_q_pressed() -> void:
	#check
	if questionNum == 1:
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
		var allChecked = true
		for i in range(0, 19):
			if(answerSet[i] == 0):
				#you have not answered every question and there will be a warning
				allChecked = false
				#maybe get a warning
				
				#append each question that you haven't checked to a string and display it afterwards
				
		#obligatory are you sure you want to submit warning
	else:
		#increment
		questionNum = questionNum + 1
	#update

func updateQuestion() -> void:
	var qID = questionSet[questionNum]
	
	#retrieve data
	
	#update:
	$emailAddress.text = "a"
	$emailSubject.text = "ab"
	$emailBody.text = "b"
	
	$questionItself.text = "c"
	$answer1.text = "d"
	$answer2.text = "e"
	$answer3.text = "f"
	$answer4.text = "g"
	


func _on_option_a_pressed() -> void:
	answerSet[questionNum]
	
