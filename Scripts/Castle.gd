extends StaticBody

onready var selection_circle = $"SelectionCircle"
onready var health_label = $"Control/Panel/HealthLabel"
onready var units_label = $"Control/Panel/UnitsLabel"
onready var control = $"Control"
var hp = 20

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
