extends Area2D

@export  var speed = 5100;
var screen_size # Size of the game windo
enum sky_positions {UP, MIDLE, BOTTOM}
var row_size= 180
var padding = 10
var player_sky_pos = sky_positions.UP
var moving = false
var calling_key = ""

signal hit


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	print("colide")
	
	
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
	var user_config = fload()
	print(user_config.phone)


func fload():
	var file = FileAccess.open("res://config.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var result_json = JSON.parse_string(content)
	return result_json

func go_fly():
	moving = true
	$AnimatedSprite2D.animation = "walk"
	
	calling_key = ""




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if moving == false:
		if Input.is_action_pressed("move_down") or calling_key == "down" :
			player_sky_pos +=1
			if player_sky_pos >2: 
				player_sky_pos = 2
			go_fly()
		if Input.is_action_pressed("move_up") or calling_key == "up" :
			player_sky_pos -=1
			if player_sky_pos <0: 
				player_sky_pos = 0
			go_fly()
	if Input.is_action_pressed("get_command"):
		$HTTPRequest.request("http://testrest.mehappy.ru/godot/command.php")

	



		
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
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	calling_key = json.key
	print(json.key)


func _on_request_timer_timeout():
	$HTTPRequest.request("http://testrest.mehappy.ru/godot/command.php?phone=79651977888")
