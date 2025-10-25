extends Area2D

var damage : int = 0
var level : int = 0
@onready var sprite: AnimatedSprite2D = $sprite
var delay = 1 # 1 seccond delay between attacks

func _ready() -> void:
	damage = 50 + level * 10


func _on_sprite_animation_finished() -> void:
	for i in get_overlapping_areas():
		if i.is_in_group("enemy"):
			i.hit(damage)

	self.queue_free()
