extends RayCast

onready var anim = $"../AnimationPlayer"

func _physics_process(delta):
	var collider = get_collider()
	if collider and collider is Enemy:
		anim.play("Attack")
