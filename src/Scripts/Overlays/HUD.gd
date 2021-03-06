extends CanvasLayer

signal start_game
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	#$StartButton.show()
	find_node('StartButton').show()
	find_node('ExitButton').show()
	#$MessageLabel.text = "Dodge the\nCreeps!"
	#$MessageLabel.show()
	$ScoreLabel.show()
	$MarginContainer.show()
	#$ExitButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func _on_StartButton_pressed():
	find_node('StartButton').hide()
	find_node('ExitButton').hide()
	#$StartButton.hide()
	#$ExitButton.hide()
	$OpeningCanvas.get_node("OpeningControl").hide()
	$MarginContainer.hide()
	emit_signal("start_game")
	
func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_ExitButton_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("Pause"): 
		get_tree().paused = true
		$PauseMenuContainer.show()


func _on_ResumeButton_pressed():
	get_tree().paused = false
	$PauseMenuContainer.hide()
