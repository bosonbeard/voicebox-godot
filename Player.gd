extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$HTTPRequest.connect("request_completed", _on_http_request_request_completed)


func _on_http_request_request_completed(result, response_code, headers, body):

	var json = JSON.stringify(body.get_string_from_utf8())
	print(json)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		#print("lol")
		velocity.x += 10
	else:
		var direction = Input.get_axis("ui_left", "ui_right")
		#print("floor")
	# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$HTTPRequest.request("http://www.mocky.io/v2/5185415ba171ea3a00704eed")

	# Get the input direction and handle the movement/deceleration.
	# As good          practice, you should replace UI actions with custom gameplay actions.
	
		if direction:
			velocity.x = direction * SPEED 
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED )

	move_and_slide()



