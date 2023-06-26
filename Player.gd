extends Area2D

@export  var speed = 5100; #player speed
var screen_size # Size of the game windo
enum sky_positions {UP, MIDLE, BOTTOM, GROUND}
var row_size= 180  # size to screen cell for player movement in pixels
var player_sky_pos = sky_positions.UP
var moving = false
var calling_key = ""
var user_config  = "" #config from file

#signal for collision
signal hit

# collision logic
func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

# initiate player for game		
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.y = 0
	moving = false
	$AnimatedSprite2D.animation = "stand"
	$AnimatedSprite2D.play()
	#get config from file
	user_config = fload()

# read config from JSON file
func fload():
	var file = FileAccess.open("res://game-config.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var result_json = JSON.parse_string(content)
	return result_json

#logic for player's movement
func go_fly():
	moving = true
	$AnimatedSprite2D.animation = "walk"
	calling_key = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity = Vector2.ZERO # The player's movement vector.
	
	# Player can't move before last movement ended
	if moving == false:
		# read keyboard keys or API command's state
		if Input.is_action_pressed("move_down") or calling_key == "down" :
			player_sky_pos +=1
			if player_sky_pos > sky_positions.BOTTOM: 
				player_sky_pos = sky_positions.BOTTOM
			go_fly()
		if Input.is_action_pressed("move_up") or calling_key == "up" :
			player_sky_pos -=1
			if player_sky_pos < sky_positions.UP: 
				player_sky_pos = sky_positions.UP
			go_fly()

	# check the position boundary for move player to current state
	if round(position.y) > ((player_sky_pos)  * row_size) : 
		velocity.y -=  (speed * delta)
		
	elif round(position.y) < ((player_sky_pos )  * row_size) :
		velocity.y +=  (speed * delta)
	else:
		velocity.y =0
		position.y = player_sky_pos   * row_size

		moving = false
		$AnimatedSprite2D.animation = "stand"
		
	position += velocity * delta
	
	# axis x player boundary (it's not critical you may  remove it)
	position.x = clamp(position.x, 0, screen_size.x)


# parse response after request to API success ended  
func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	calling_key = json.key

#regular calling API by timer
func _on_request_timer_timeout():
	$HTTPRequest.request(user_config.server_url+"/command.php?phone="+user_config.phone)

