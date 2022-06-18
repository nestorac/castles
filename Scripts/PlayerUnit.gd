extends KinematicBody

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
	movement(delta)

func movement(delta):
	if path_index < path.size():
		var move_vector = path[path_index] - global_transform.origin
		if move_vector.length() < 1:
			path_index += 1
		else:
			look_at(path[path_index],Vector3.UP)
			move_and_slide(move_vector.normalized() * SPEED * delta, Vector3.UP)

func create_path(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	path_index = 0

func _on_Flag_placed(flag_position):
	create_path(flag_position)

func _on_Flag_removed():
	path_index = path.size()
