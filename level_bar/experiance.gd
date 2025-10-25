extends Area2D
@onready var anim: AnimationPlayer = $anim
var picked_up : bool = false
var target : Node2D = null

func _process(delta: float) -> void:
	if picked_up and target:
		position = lerp(position,target.position,delta*10)

func _on_body_entered(body: Node2D) -> void:
	picked_up = true
	if body is Player: 
		target = body
		Globals.experiance += 1
		anim.play("anim")
		await anim.animation_finished
		print("Killed Experiance Orb")
		queue_free()
