extends "res://Scripts/Enemies/baseEnemy.gd"

export (PackedScene) var Projectile

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$AnimatedSprite.animation = "idle"
	health = 40
	$StandardFireTimer.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_SquidSpawner_body_shape_entered(body_id, body, body_shape, local_shape):
	print("You hit de squid")
	if(!body.get_friendly()):
		return
	var hitEffect = Blood.instance()
	#hitEffect.position = body.position
	add_child(hitEffect)
	if(health > 0):
		health -= body.get_damage()
	else:
		hide()
		$CollisionShape2D.disabled = true

func _on_StandardFireTimer_timeout():
	var proj = Projectile.instance()
	add_child(proj)
	# set the mob's direction perpendicular to the path direction
	var direction = rotation + PI/2
	# set the mob's position to a random location
	# add some randomness to the direction
	direction += rand_range(-PI/4, PI/4)
	#proj.rotation = direction
	# choose the velocity
	proj.set_linear_velocity(Vector2(rand_range(proj.get_speed(), proj.get_speed()), 0).rotated(direction))
