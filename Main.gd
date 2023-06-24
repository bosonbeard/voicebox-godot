extends Node

@export var cloud_scene: PackedScene
@export var mob_scene: PackedScene
var start_pos = Vector2(25,1)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_timer_timeout():
	$CloudTimer.start()
	$MobTimer.start()
	$FinishTimer.start()
	

func game_over():
	$MobTimer.stop()
	$CloudTimer.stop()
	$FinishTimer.stop()
	$HUD.show_game_over()
	
	
func victory():
	$MobTimer.stop()
	$CloudTimer.stop()
	$FinishTimer.stop()
	$HUD.show_victory()
	get_tree().call_group("mobs", "queue_free")	
	$Player.player_sky_pos = $Player.sky_positions.GROUND
	$Player.get_node("AnimatedSprite2D").animation = "walk"
	

func new_game():
	$HUD.show_message("Get Ready")
	$Player.start(start_pos)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")	
	$Player.player_sky_pos = $Player.sky_positions.UP

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

	# Spawn the cloud by adding it to the Main scene.
	add_child(cloud)



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


