extends RigidBody2D

func _ready():
	$DestructTimer.start()

func _on_DestructTimer_timeout():
	queue_free()