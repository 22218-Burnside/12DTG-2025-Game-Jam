extends Area2D
class_name Enemy

signal death
signal enemy_hit_player

var points = 10
var player : Node2D
var can_attack = true
var time = 0

var health
var parent

@export var enemy_type : EnemyType
@onready var sprite: AnimatedSprite2D = $sprite
@onready var anim: AnimationPlayer = $anim
@onready var attack_timer: Timer = $attack_timer

const BLOOD = preload("uid://c86x45q5nqmiw")
const DAMAGE_INDICATOR = preload("uid://drucr8c11yv4b")
const EXPERIANCE = preload("uid://cwfm62bvsyiby")


func _ready() -> void:
	parent = get_parent()
	
	if enemy_type:
		health = enemy_type.enemy_health
		attack_timer.wait_time = enemy_type.enemy_attack_cooldown
		
		sprite.sprite_frames = enemy_type.enemy_anims
		sprite.play(enemy_type.enemy_walk_anim)
		
	if parent:
		player = get_parent().get_node("player")
		enemy_hit_player.connect(parent._on_enemy_enemy_hit_player)
		death.connect(parent._on_enemy_killed)
	

func _physics_process(delta: float) -> void:
	time += 1
	sprite.skew = sin(time/5) / 10
	
	var direction = player.position.x - position.x
	if direction > 0: sprite.flip_h = true
	else: sprite.flip_h = false

	if can_attack:
		for body in get_overlapping_bodies():
			if body is Player:
				can_attack = false
				enemy_hit_player.emit(enemy_type.damage)
				attack_timer.start()
				
	position += enemy_type.enemy_speed * position.direction_to(player.position) * delta

func hit(inflicted_damage := 1.0): 
	health -= inflicted_damage
	
	var ind = DAMAGE_INDICATOR.instantiate()
	get_parent().add_child(ind)
	ind.position = global_position
	
	if health <= 0: die()
	else: anim.play("hurt")

func die():	
	var exper = EXPERIANCE.instantiate()
	get_parent().add_child(exper)
	exper.position = position
	
	var blood = BLOOD.instantiate()
	get_parent().add_child(blood)
	blood.position = position
	
	death.emit(points,self.position)
	self.queue_free()


func _on_attack_timer_timeout() -> void:
	can_attack = true
