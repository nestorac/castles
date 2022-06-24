extends KinematicBody

class_name PlayerUnit

var enemies = []

# State machine
enum{IDLE, MOVING, CHASING, ATTACKING}

var state = IDLE

# For pathfinding
var path = []
var path_index = 0
const SPEED = 500
onready var navigation = get_parent().get_parent()
onready var flag = $"../../../Flag"


func _ready():
	flag.connect("flag_placed", self, "_on_Flag_placed")
	flag.connect("flag_removed", self, "_on_Flag_removed")


func _physics_process(delta):
	match state:
		IDLE:
			pass
		MOVING:
			movement(delta)
		CHASING:
			movement(delta)
		ATTACKING:
			pass


func movement(delta):
	if path_index < path.size():
		var move_vector = path[path_index] - global_transform.origin
		if move_vector.length() < 1:
			path_index += 1
		else:
			look_at(path[path_index],Vector3.UP)
			move_and_slide(move_vector.normalized() * SPEED * delta, Vector3.UP)
	else:
		if enemies.empty():
			state = IDLE
		else:
			state = CHASING
			create_path(enemies.front().global_transform.origin)


func create_path(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	path_index = 0
	return path


func _on_Flag_placed(flag):
#	print(flag.positions)
	randomize()
	flag.positions.shuffle()
	var unit_path = create_path(flag.positions.front().global_transform.origin)
	if unit_path.empty():
		create_path(flag.global_transform.origin)
	state = MOVING


func _on_Flag_removed():
	path_index = path.size()
	if enemies.empty():
		state = IDLE
	else:
		state = CHASING
		create_path(enemies.front().global_transform.origin)


func _on_VisionBox_body_entered(body):
	if body is Enemy:
		enemies.append(body)
		state = CHASING
		create_path(enemies.front().global_transform.origin)


func _on_VisionBox_body_exited(body):
	if body is Enemy:
		enemies.erase(body)
		if state == MOVING:
			return
		if enemies.empty():
			state = IDLE
		else:
			state = CHASING
			create_path(enemies.front().global_transform.origin)
