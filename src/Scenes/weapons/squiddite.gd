extends "res://Scripts/Weapons/projectile.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	friendly = 0
	set_damage(2)
	set_speed(500)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
