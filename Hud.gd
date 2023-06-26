extends CanvasLayer

signal start_game


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	

func fload():
	var file = FileAccess.open("res://game-config.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var result_json = JSON.parse_string(content)
	return result_json
	
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Kuzma - the flying cat!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$LinkButton.show()
	
func show_victory():
	show_message("You win!")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Kuzma - the flying cat!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$LinkButton.show()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$LinkButton.uri=fload().story_url


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_message_timer_timeout():
	$Message.hide()
	


func _on_start_button_pressed():
	$StartButton.hide()
	$LinkButton.hide()
	start_game.emit()	
		



