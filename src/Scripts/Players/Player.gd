extends Area2D

export (PackedScene) var Projectile
export (PackedScene) var Levelup

signal hit
export (int) var SPEED # how fast the player will move (pixels/sec)
var ROTATE_QUARTER = 1.5708;

var screensize #size of game window

var maxBullets = 5
var bulletsOnScreen = 0
var canFire = true

var invulnerable = false
var dodgePause = false
var dodging = false
var dodgeDirection = 1
var canDodge = true
var lastVelocity

var speedAffection = 1

var fireDirection = 1
var fireXOffset = 0
var fireYOffset = 0
var controlsMuted = 0

var playerExperience = 0
var playerLevel = 0
var playerSkillPoints = 0
var levelCaps = [20,200,400,800,1600,3200,4400, 6000]

var damageAmplifier = 0
var criticalStrike = 0
var pushForce = 0
var defense = 0

func _ready():
	screensize = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2() # the player's movement vector	
	if(!dodging):
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
			fireDirection = 1
			processDodge()
			$DodgeDetectTimer.start()			
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
			fireDirection = 3
			processDodge()
			$DodgeDetectTimer.start()
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
			fireDirection = 2
			processDodge()
			$DodgeDetectTimer.start()
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
			fireDirection = 0
			processDodge()
			$DodgeDetectTimer.start()
		if velocity.length() > 0:
			velocity = velocity.normalized() * (SPEED * speedAffection)
			$AnimatedSprite.play()
		else:
			dodgePause = true
			$AnimatedSprite.stop()
		dodgeDirection = fireDirection
		position += velocity * delta
		#position.x = clamp(position.x, 0, screensize.x)
		#position.y = clamp(position.y, 0, screensize.y)
		lastVelocity = velocity
		if velocity.x != 0:
			$AnimatedSprite.animation = "right"
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite.animation = "up"
			#$AnimatedSprite.flip_v = velocity.y > 0
		if Input.is_action_pressed("ui_select"):
			fire()
	else:
		position += lastVelocity * delta
		#position.x = clamp(position.x, 0, screensize.x)
		#position.y = clamp(position.y, 0, screensize.y)
		$AnimatedSprite.animation = "side_dodge"
		$AnimatedSprite.play()

func processDodge():
	if(!dodgePause || !canDodge):
		return
	if(!$DodgeDetectTimer.is_stopped() && fireDirection == dodgeDirection):
		dodging = true
		canDodge = false
		speedAffection = 2
		$AnimatedSprite.animation = "side_dodge"
		$AnimatedSprite.play()
		$DodgeDetectTimer.stop()
		$ActivelyDodgingTimer.start()
		$DodgeDelayTimer.start()
		if (lastVelocity.x != 0):
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.flip_h = lastVelocity.x < 0
	dodgePause = false

func _on_Player_body_entered(body):
	if(body.get_name() == "TileMap"):
		lastVelocity.x *= -.05
		lastVelocity.y *= -.05
		position += lastVelocity
		return
	if(dodging):
		return
	if(body.get_friendly()):
		return
	hide()
	emit_signal("hit")
	$CollisionShape2D.disabled = true

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$FireRangeTimer.start()

func addBullet():
	if(bulletsOnScreen > 0):
		bulletsOnScreen -= 1

func set_experience(experience):
	playerExperience = experience	

func get_experience():
	return playerExperience

func add_experience(experience):
	playerExperience += experience
	if(levelCaps[playerLevel] < playerExperience):
		playerLevel += 1
		playerSkillPoints += 1
		var levelAnim = Levelup.instance()
		add_child(levelAnim)

func set_level(Level):
	playerLevel = Level

func get_level():
	return playerLevel

func add_level(Level):
	playerLevel += Level

func set_skill_points(SkillPoints):
	playerSkillPoints = SkillPoints	

func get_skill_points():
	return playerSkillPoints

func add_skill_points(SkillPoints):
	playerSkillPoints += SkillPoints

func fire():
	if(bulletsOnScreen >= maxBullets || canFire == false):
		return
	var knife = Projectile.instance()
	# Rotate knife according to the firing direction
	var knifeRot = ROTATE_QUARTER * fireDirection
	# Adjusting velocity to match rotation
	var velRot = ROTATE_QUARTER * (fireDirection - 1)
	get_owner().add_child(knife)
	knife.position = position
	#print($CollisionShape2D.get_shape().height)
	knife.rotation = knifeRot
	knife.set_creator(self)
	knife.set_linear_velocity(Vector2(knife.get_speed(), 0).rotated(velRot))
	canFire = false
	$FireSpeedTimer.start()
	bulletsOnScreen += 1

func _on_FireSpeedTimer_timeout():
	canFire = true


func _on_DodgeDelayTimer_timeout():
	canDodge = true

func _on_DodgeDetectTimer_timeout():
	dodgePause = false
	
func _on_ActivelyDodgingTimer_timeout():
	dodgePause = false
	dodging = false
	speedAffection = 1
	$AnimatedSprite.animation = "right"
