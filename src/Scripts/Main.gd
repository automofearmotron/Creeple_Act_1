extends Node

export (PackedScene) var Mob
var score
var currentSong

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	randomize()
	currentSong = AudioStreamPlayer.new()
	var audioFile = "res://Audio/Music/wavs/Creeples_Sketch_1.wav"
	var music = load(audioFile)
	currentSong.stream = music
	currentSong.play()
	currentSong.volume_db = -15
	add_child(currentSong)
	#var screen_size = OS.get_screen_size()
	#var window_size = OS.get_window_size()
	
	#OS.set_window_position(screen_size - window_size)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	var audioFile = "res://Audio/Music/wavs/Creeples_Overworld.wav"
	var music = load(audioFile)
	currentSong.stream = music
	currentSong.play()
	currentSong.volume_db = -15
	$Level_BG.show()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
	
func _on_MobTimer_timeout():
	# choose a random location on Path2D
	$MobPath/MobSpawnLocation.set_offset(randi())
	# create a Mob instance and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	# set the mob's direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	# set the mob's position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	mob.apply_scale(Vector2(.1,.1))
	# add some randomness to the direction
	direction += rand_range(-PI/4, PI/4)
	#mob.rotation = direction
	# choose the velocity
	#mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction))