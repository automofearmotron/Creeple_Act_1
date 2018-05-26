extends Area2D

export (PackedScene) var Projectile

signal hit
export (int) var SPEED # how fast the player will move (pixels/sec)
var ROTATE_QUARTER = 1.5708;
var screensize #size of game window
var maxBullets = 5
var bulletsOnScreen = 0
var canFire = true
var fireDirection = 1

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	screensize = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2() # the player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		fireDirection = 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		fireDirection = 3
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		fireDirection = 2
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		fireDirection = 0
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		#$AnimatedSprite.flip_v = velocity.y > 0
	if Input.is_action_pressed("ui_select"):
		fire()

func _on_Player_body_entered(body):
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
	

func fire():
	if(bulletsOnScreen >= maxBullets || canFire == false):
		return
	var knife = Projectile.instance()
	var knifeRot = ROTATE_QUARTER * fireDirection
	var velRot = ROTATE_QUARTER * (fireDirection - 1)
	get_owner().add_child(knife)
	knife.position = position
	knife.rotation = knifeRot
	knife.set_linear_velocity(Vector2(knife.get_speed(), 0).rotated(velRot))
	canFire = false
	$FireSpeedTimer.start()
	bulletsOnScreen += 1

func _on_FireSpeedTimer_timeout():
	canFire = true
