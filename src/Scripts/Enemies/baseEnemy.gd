extends KinematicBody2D

export (int) var MIN_SPEED
export (int) var MAX_SPEED
export (int) var INIT_HEALTH
var friendly = 0
var health = 1
var experienceValue = 10
var velocity = Vector2()

export (PackedScene) var Blood

func _process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var body = collision_info.collider
		velocity = velocity.bounce(collision_info.normal)
		if(body.get_name() == "TileMap"):
			return
		if(!body.get_friendly()):
			return
		var hitEffect = Blood.instance()
		add_child(hitEffect)
		hitEffect.global_position = body.get_contact_point()
		$AnimatedSprite.animation = "hit"
		$AnimatedSprite.play()
		if(health > 0):
			health -= body.get_damage()
		else:
			$AnimatedSprite.animation = 'death'
			$CollisionShape2D.disabled = true
			$DeathNote.play()
			body.get_creator().add_experience(experienceValue)
			print(body.get_creator().get_experience())

func _ready():
	velocity.x = MIN_SPEED
	velocity.y = MIN_SPEED
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play()
	
func set_friendly(friendlyIn):
	friendly = friendlyIn

func get_friendly():
	return friendly
	
func set_health(healthIn):
	health = healthIn
	
func get_health():
	return health

func get_experience():
	return experienceValue
	
func set_experience(expIn):
	experienceValue = expIn
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'hit':
		$AnimatedSprite.animation = 'idle'
	elif $AnimatedSprite.animation == 'death':
		kill_self()

func kill_self():
	hide()
	$CollisionShape2D.disabled = true
	queue_free()
	
func _on_Mob_body_shape_entered(body_id, body, body_shape, local_shape):
	if(body.get_name() == "TileMap"):
		return
	if(!body.get_friendly()):
		return
	var hitEffect = Blood.instance()
	#hitEffect.position = body.position
	add_child(hitEffect)
	print(hitEffect.global_position)
	print(body.get_contact_point())
	hitEffect.global_position = body.get_contact_point()
	$AnimatedSprite.animation = "hit"
	if(health > 0):
		health -= body.get_damage()
	else:
		body.get_creator().add_experience(experienceValue)
		kill_self();
