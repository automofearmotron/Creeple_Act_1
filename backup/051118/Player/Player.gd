extends Area2D

export (PackedScene) var Knife

signal hit
export (int) var SPEED # how fast the player will move (pixels/sec)
var screensize #size of game window
var maxBullets = 5
var bulletsOnScreen = 0
var canFire = true
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
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	if Input.is_action_pressed("ui_select"):
		fire()
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
	var knife = Knife.instance()
	get_owner().add_child(knife)
	knife.position = position
	knife.rotation = 1.5708
	knife.set_linear_velocity(Vector2(knife.get_speed(), 0).rotated(0))
	canFire = false
	$FireSpeedTimer.start()
	bulletsOnScreen += 1

func _on_FireSpeedTimer_timeout():
	canFire = true
