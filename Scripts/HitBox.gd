extends Area

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.has_method("get_damage"):
		body.get_damage(1)
