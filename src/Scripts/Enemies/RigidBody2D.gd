extends RigidBody2D

export (int) var MIN_SPEED
export (int) var MAX_SPEED
var friendly = 0
var mob_types = ["walk","swim","fly"]

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_friendly(friendlyIn):
	friendly = friendlyIn

func get_friendly():
	return friendly

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
