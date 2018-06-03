extends RigidBody2D

export (int) var MIN_SPEED
export (int) var MAX_SPEED
var friendly = 0
var health = 2
var mob_types = ["walk","swim","fly"]
export (PackedScene) var Blood

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func set_friendly(friendlyIn):
	friendly = friendlyIn

func get_friendly():
	return friendly

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Mob_body_shape_entered(body_id, body, body_shape, local_shape):
	if(body.get_name() == "TileMap"):
		queue_free()
		return
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
