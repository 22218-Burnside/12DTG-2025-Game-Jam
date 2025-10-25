extends Area2D

var speed : int = 20
var health = 100
var damage = 10
var points = 10
var player : Node2D
var can_attack = true

signal death
signal enemy_hit_player


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var die_anim: AnimationPlayer = $anim
const BLOOD = preload("uid://c86x45q5nqmiw")
const DAMAGE_INDICATOR = preload("uid://drucr8c11yv4b")
const EXPERIANCE = preload("uid://cwfm62bvsyiby")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("player")
	enemy_hit_player.connect($".."._on_enemy_enemy_hit_player)
	death.connect($".."._on_enemy_killed)
	


func _physics_process(delta: float) -> void:
	var direction = player.position.x - position.x
	if direction > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
		#$Icon.flip_v = false

	if can_attack:
		for i in get_overlapping_bodies():
			if i.name == "player":
				can_attack = false
				enemy_hit_player.emit(damage)
				$attack_timer.start(1.5)
	position += speed * position.direction_to(player.position) * delta

func hit(inflicted_damage := 1.0): 
	health -= inflicted_damage
	
	var ind = DAMAGE_INDICATOR.instantiate()
	get_parent().add_child(ind)
	ind.position = global_position
	
	if health <= 0:
		die()
	else:
		die_anim.play("hurt")

func die():
	# creates a blood particles that kills itself after emmiting. Also plays
	# an animation showing the enemy dissolving. Await waits for the animation
	# to finish before queue freeing
	
	var exper = EXPERIANCE.instantiate()
	get_parent().add_child(exper)
	exper.position = position
	
	death.emit(points,self.position)
	var blood = BLOOD.instantiate()
	get_parent().add_child(blood)
	blood.position = position
	self.queue_free()



func _on_attack_timer_timeout() -> void:
	can_attack = true
