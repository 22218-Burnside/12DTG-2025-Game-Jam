extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 100
var controlling = false

func setup():
	controlling = true
	health = 100
	$"../level_ui/ProgressBar".value = health

func _physics_process(_delta: float) -> void:
	if controlling:
		var direction_x := Input.get_axis("left", "right")
		if direction_x:
			velocity.x = direction_x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		var direction_y := Input.get_axis("up", "down")
		if direction_y:
			velocity.y = direction_y * SPEED
		else:
			velocity.y = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
