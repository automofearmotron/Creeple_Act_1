extends CollisionPolygon2D

var isFriendly = 1
var isObstacle = 1

func _ready():
	pass

func set_friendly(friendlyIn):
	isFriendly = friendlyIn
	
func get_friendly():
	return isFriendly
	
func get_obstacle():
	return isObstacle
	
func set_obstacle(obstacleIn):
	isObstacle = obstacleIn