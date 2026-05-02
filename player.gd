extends CharacterBody3D

var speed = 5.0
var target_position: Vector3
var is_moving = false

func _physics_process(delta):
	if is_moving:
		var direction = (target_position - global_position).normalized()
		var distance = global_position.distance_to(target_position)
		
		if distance > 0.1:
			velocity = direction * speed
			move_and_slide()
		else:
			is_moving = false
			velocity = Vector3.ZERO
