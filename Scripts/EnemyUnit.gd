extends KinematicBody

class_name Enemy

enum {MOVE_TO_CASTLE, CHASING, ATTACK_CASTLE}
var state = MOVE_TO_CASTLE

onready var debug_label = $"Control/DebugLabel"

var enemies = []
onready var castle = get_tree().get_nodes_in_group("PlayerCastle")
var hp = 5

# For pathfinding
var path = []
var path_index = 0
const SPEED = 500
onready var navigation = get_parent().get_parent()


func _process(delta):
	match state:
		MOVE_TO_CASTLE:
			movement(delta)
			debug_label.text = "state: MOVE TO CASTLE"
		CHASING:
			movement(delta)
			debug_label.text = "state: CHASING"
		ATTACK_CASTLE:
			attack_castle(delta)
			debug_label.text = "state: ATTACK CASTLE"


func attack_castle(delta):
	if path_index < path.size():
		var move_vector = path[path_index] - global_transform.origin
		if move_vector.length() < 1:
			path_index += 1
		else:
			look_at(castle[0].global_transform.origin, Vector3.UP)
			move_and_slide(move_vector.normalized() * SPEED * delta, Vector3.UP)


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
			var random = randi() % castle[0].enemy_positions.get_child_count()
			create_path(castle[0].enemy_positions.get_child(random).global_transform.origin)
			state = MOVE_TO_CASTLE
		else:
			state = CHASING
			create_path(enemies.front().global_transform.origin)


func create_path(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	path_index = 0
	return path

func get_damage(damage):
	hp -= damage
	if hp <= 0:
		queue_free()


func _on_VisionBox_body_entered(body):
	if state == ATTACK_CASTLE:
		return
	if body.is_in_group("PlayerUnit"):
		enemies.append(body)
		state = CHASING
		create_path(enemies.front().global_transform.origin)
	elif body.is_in_group("PlayerCastle"):
		var random_number = randi() % castle[0].enemy_positions.get_child_count()
		print(random_number)
		create_path(castle[0].enemy_positions.get_child(random_number).global_transform.origin)
		print ("Attack castle")
		state = ATTACK_CASTLE

func _on_VisionBox_body_exited(body):
	if state == ATTACK_CASTLE:
		return
	if body.is_in_group("PlayerUnit"):
		enemies.erase(body)
		if enemies.empty():
			if state == ATTACK_CASTLE:
				return
			else:
				state = MOVE_TO_CASTLE
		else:
			state = CHASING
			create_path(enemies.front().global_transform.origin)
