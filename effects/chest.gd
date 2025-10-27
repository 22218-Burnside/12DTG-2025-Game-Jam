extends Area2D

@onready var anim: AnimatedSprite2D = $anim

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		anim.play("new_animation")
		await anim.animation_finished
		get_parent().choose_new_element()
