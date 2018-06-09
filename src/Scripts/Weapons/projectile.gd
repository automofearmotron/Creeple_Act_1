extends RigidBody2D

var base_damage = 1
var speed = 1
var friendly = 1
var creator

func _ready():
	$DistanceTimer.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_damage(damage):
	base_damage = damage

func set_speed(speedIn):
	speed = speedIn

func get_damage():
	return base_damage

func get_speed():
	return speed

func set_friendly(friendlyIn):
	friendly = friendlyIn
	
func get_friendly():
	return friendly
	
# Owners are the enemies/players that create projectiles
func set_creator(creatorIn):
	creator = creatorIn
	
func get_creator():
	return creator
	
func get_contact_point():
	return $ContactPoint.global_position
	
func _on_DistanceTimer_timeout():
	queue_free()