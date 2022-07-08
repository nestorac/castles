extends StaticBody

onready var enemy_positions = $"EnemyPositions"
onready var selection_circle = $"SelectionCircle"
onready var health_label = $"Control/Panel/HealthLabel"
onready var units_label = $"Control/Panel/UnitsLabel"
onready var control = $"Control"
onready var spawn_points = $"SpawnPoints"
var hp = 20

export var units_limit = 10

export(PackedScene) var unit_scene

export(NodePath) onready var units_node = get_node(units_node) as Spatial
export(NodePath) onready var other_castle = get_node(other_castle) as StaticBody

func select_castle():
	deselect_castle(other_castle)
	var total_units = units_node.get_child_count()
	units_label.text = "Units: " + str(total_units)
	health_label.text = "Health: " + str(hp)
	selection_circle.show()
	control.show()

func deselect_castle(castle):
	castle.control.hide()
	castle.selection_circle.hide()

func spawn_unit():
	var unit_instance = unit_scene.instance()
	var random = randi() % spawn_points.get_child_count()
	
	units_node.add_child(unit_instance)
	unit_instance.global_transform.origin = spawn_points.get_child(random).global_transform.origin
	print("Spawn child.")

func _on_Timer_timeout():
	if (units_node.get_child_count() < units_limit):
		spawn_unit()
