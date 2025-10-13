extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 100
var score = 0
var attack_time = 0.5
var controlling = false

@onready var attack = preload("res://prefabs/attack.tscn")
func setup():
	controlling = true
	health = 100
	score = 0
	$".."/level_ui/Label.text = "Score: 0"
	$"../level_ui/ProgressBar".value = health
	fire_attack()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Marker.position = get_global_mouse_position()


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

func fire_attack():
	if controlling:
		$attack_timer.start(attack_time)
		var spawned_attack = attack.instantiate()
		$"..".add_child(spawned_attack)
		spawned_attack.position = self.position
		spawned_attack.direction = ($Marker.position-self.position).normalized()
