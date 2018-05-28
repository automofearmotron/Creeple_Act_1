extends "res://Scripts/weapons/projectile.gd"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_damage(1)
	set_speed(500)
	var swoosh = (randi() % 3) + 1
	match swoosh:
		1:
			$Swoosh_1.play()
		2:
			$Swoosh_2.play()
		3:
			$Swoosh_3.play()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
