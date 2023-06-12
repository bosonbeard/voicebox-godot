extends Area2D

@export  var speed = 4000;
var screen_size # Size of the game windo
enum sky_positions {UP, MIDLE, BOTTOM}
var row_size= 200
var padding = 10
var player_sky_pos = sky_positions.UP
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.y = 0
	moving = false
	$AnimatedSprite2D.animation = "stand"
	$AnimatedSprite2D.play()


func fload():
	var file = FileAccess.open("res://config.cfg", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return String(content)

func go_fly():
	moving = true
	$AnimatedSprite2D.animation = "walk"
	print ("FLY")
	var a = fload()
	print(a)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if moving == false:
		if Input.is_action_pressed("move_down"):
			player_sky_pos +=1
			if player_sky_pos >2: 
				player_sky_pos = 2
			print ("DOWN")
			go_fly()
		if Input.is_action_pressed("move_up"):
			player_sky_pos -=1
			if player_sky_pos <0: 
				player_sky_pos = 0
			print ("UP")
			go_fly()
	
	



		
	if round(position.y) > ((player_sky_pos)  * row_size) : 
		velocity.y -=  (speed * delta)
		
	elif round(position.y) < ((player_sky_pos )  * row_size) :
		velocity.y +=  (speed * delta)
	else:
		velocity.y =0
		position.y = player_sky_pos   * row_size
		print ( "aaaa")
		moving = false
		$AnimatedSprite2D.animation = "stand"
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
