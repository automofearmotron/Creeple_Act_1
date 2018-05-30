extends TileMap

var isFriendly = 1
var isObstacle = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_friendly(friendlyIn):
	isFriendly = friendlyIn
	
func get_friendly():
	return isFriendly
	
func get_obstacle():
	return isObstacle
	
func set_obstacle(obstacleIn):
	isObstacle = obstacleIn