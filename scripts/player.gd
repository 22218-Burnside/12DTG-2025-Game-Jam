extends CharacterBody2D


const SPEED = 300.0
var health = 100
var score = 0
var xp = 0
var coins = 0

var level = 1
const LEVEL_BASE = 100
const LEVEL_INCREMENT = 20

var attack_time = 0.75
var controlling = false
var can_hit = true

@onready var attack = preload("res://prefabs/attack.tscn")
func setup():
	controlling = true
	health = 100
	score = 0
	$".."/level_ui/Label.text = "Score: 0"
	$"../level_ui/ProgressBar".value = health
	fire_attack()

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


func update_stats():
	$".."/level_ui/Label.text = "Score: " + str(score)
	$"../level_ui/ProgressBar".value = health
	if xp >= LEVEL_BASE + LEVEL_INCREMENT * (level - 1):
		print("level up", xp)
	
	
func fire_attack():
	if controlling:
		$attack_timer.start(attack_time)
		var spawned_attack = attack.instantiate()
		$"..".add_child(spawned_attack)
		spawned_attack.position = self.position
		spawned_attack.direction = (get_global_mouse_position()-self.position).normalized()


func _on_immunity_timer_timeout() -> void:
	can_hit = true
	$".."/level_ui/immunity.hide()
