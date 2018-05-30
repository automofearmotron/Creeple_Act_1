extends "res://Scripts/Enemies/baseEnemy.gd"

export (PackedScene) var Projectile

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$AnimatedSprite.animation = "idle"
	health = 40
	$StandardFireTimer.start()
	$SalvoTimer.start()
	fireSalvo()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func fireSalvo():
	var rotater = 0
	for i in range(12):
		var proj = Projectile.instance()
		add_child(proj)
		var direction = rotation + rotater
		# add some randomness to the direction
		proj.rotation = rotater + PI/2
		# choose the velocity
		$AnimatedSprite.animation = "idle"
		proj.set_linear_velocity(Vector2(rand_range(proj.get_speed(), proj.get_speed()), 0).rotated(rotater))
		rotater += PI/4
	

func _on_SquidSpawner_body_shape_entered(body_id, body, body_shape, local_shape):
	if(body.get_name() == "TileMap"):
		return
	if(!body.get_friendly()):
		return
	var hitEffect = Blood.instance()
	#hitEffect.position = body.position
	add_child(hitEffect)
	$AnimatedSprite.animation = "hit"
	if(health > 0):
		health -= body.get_damage()
	else:
		hide()
		$CollisionShape2D.disabled = true

func _on_StandardFireTimer_timeout():
	var proj = Projectile.instance()
	add_child(proj)
	var direction = rotation + PI/2
	# add some randomness to the direction
	direction += rand_range(-PI/8, PI/8)
	proj.rotation = direction + PI/2
	# choose the velocity
	$AnimatedSprite.animation = "idle"
	proj.set_linear_velocity(Vector2(rand_range(proj.get_speed(), proj.get_speed()), 0).rotated(direction))


func _on_SalvoTimer_timeout():
	fireSalvo()
