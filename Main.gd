extends Node

@export var cloud_scene: PackedScene
@export var mob_scene: PackedScene
var score
var start_pos = Vector2(25,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_timer_timeout():
	$CloudTimer.start()
	$MobTimer.start()

	

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	%CloudTimer.stop()

func new_game():
	score = 0
	$Player.start(start_pos)
	$StartTimer.start()


func _on_cloud_timer_timeout():
	# Create a new instance of the Mob scene.
	var cloud = cloud_scene.instantiate()

	# Choose a random location on Path2D.
	var cloud_spawn_location = get_node("CloudPath/CloudSpawnLocation")
	cloud_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.


	# Set the mob's position to a random location.
	cloud.position = cloud_spawn_location.position

	# Add some randomness to the direction.

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(-105.0, -205.0), 0.0)
	cloud.linear_velocity = velocity 



	# Spawn the mob by adding it to the Main scene.
	add_child(cloud)
	print ("WTF")


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("CloudPath/CloudSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.


	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(-150.0, -160.0), 0.0)
	mob.linear_velocity = velocity

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
