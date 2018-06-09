extends "res://Scripts/Enemies/baseEnemy.gd"

func _ready():
	$AnimatedSprite.animation = 'idle'
	$AnimatedSprite.play()
	

func _on_Mob_body_shape_entered(body_id, body, body_shape, local_shape):
	._on_Mob_body_shape_entered(body_id, body, body_shape, local_shape)
