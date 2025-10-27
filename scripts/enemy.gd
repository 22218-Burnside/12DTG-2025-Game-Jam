extends CharacterBody2D
class_name Enemy

signal death
signal enemy_hit_player

var points = 10
var player : Node2D
var can_attack = true
var time = 0

var health
var parent
var dead : bool = false

@export var enemy_type : EnemyType
@onready var sprite: AnimatedSprite2D = $sprite
@onready var anim: AnimationPlayer = $anim
@onready var attack_timer: Timer = $attack_timer
@onready var detect_box: Area2D = $detect_box

const BLOOD = preload("uid://c86x45q5nqmiw")
const DAMAGE_INDICATOR = preload("uid://drucr8c11yv4b")
const EXPERIANCE = preload("uid://cwfm62bvsyiby")
const FLASH_TIMER = 0.1
const KNOCKBACK = 1
const CHEST = preload("uid://c41gvio14sn4j")

const ENEMY_DIE = preload("uid://wb0oo4qlcsuu")
const FLASH_SHADER = preload("uid://4dola2cm1n5j")


func _ready() -> void:
	sprite.material = FLASH_SHADER.duplicate()
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
	sprite.position = lerp(sprite.position,Vector2.ZERO,delta*10)
	
	if dead:
		var rate = lerp(sprite.material.get_shader_parameter("progress"),1.0,delta*5)
		sprite.material.set_shader_parameter("progress",rate)
		
		if rate >= 0.95: self.queue_free()
		
	else:
		time += 1
		sprite.skew = sin(time/5) / 10
		
		var direction = player.position.x - position.x
		if direction > 0: sprite.flip_h = true
		else: sprite.flip_h = false

		if can_attack:
			for body in detect_box.get_overlapping_bodies():
				if body is Player:
					can_attack = false
					enemy_hit_player.emit(enemy_type.ememy_damage)
					attack_timer.start()
					
		velocity = enemy_type.enemy_speed * (position.direction_to(player.position) * delta).normalized()
		move_and_slide()
		

func hit(inflicted_damage := 1.0): 
	health -= inflicted_damage
	
	var ind = DAMAGE_INDICATOR.instantiate()
	ind.damage = inflicted_damage
	get_parent().add_child(ind)
	ind.position = global_position
	
	if health <= 0: die()
	else: 
		sprite.material.set_shader_parameter("make_white",true)
		await get_tree().create_timer(FLASH_TIMER).timeout
		sprite.material.set_shader_parameter("make_white",false)

	sprite.position = -velocity.normalized() * KNOCKBACK

func die():	
	var exper = EXPERIANCE.instantiate()
	get_parent().add_child(exper)
	exper.position = position
	
	if enemy_type.drops_chest:
		var chest = CHEST.instantiate()
		get_parent().add_child(chest)
		chest.position = position
		
	death.emit(points,self.position)
	dead = true
	sprite.material = ENEMY_DIE.duplicate()


func _on_attack_timer_timeout() -> void:
	can_attack = true
