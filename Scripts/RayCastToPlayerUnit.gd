extends RayCast

onready var anim = $"../AnimationPlayer"

func _physics_process(delta):
	var collider = get_collider()
	if collider:
		if collider.is_in_group("PlayerUnit"):
			anim.play("AttackAnim")
		elif collider.is_in_group("PlayerCastle"):
			anim.play("AttackAnim")
