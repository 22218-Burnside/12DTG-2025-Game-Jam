extends Label

var domain_sequence := "domainexpansion"
var domain_progress := 0
var domain_expanding := false
var can_expand = true

func _ready() -> void:
	pass

func _input(event):
	if event is InputEventKey and not event.echo and event.unicode > 0:
		var key_char = char(event.unicode).to_lower()
		if key_char == domain_sequence[domain_progress] and can_expand:
			domain_progress += 1
			if domain_progress == domain_sequence.length() and can_expand:
				# Full sequence successful!
				$"..".show()
				$"../anukus".play()
				$"../GPUParticles2D".emitting = true
				$"../GPUParticles2D2".emitting = true
				$"../GPUParticles2D3".emitting = true
				$"../Timer".start(15)
				$"../Kill_Timer".start(0.1)
				$"../Icon".hide()
				$"../../Camera2D".shake(10.0,15.0)
				self.show()
				domain_expanding = true
				domain_progress = 0 # Reset for next time
				can_expand = false
		else:
			# Reset on wrong key or partial input error
			domain_progress = 0

func _on_timer_timeout() -> void:
	domain_expanding = false
	$"../anukus".stop()
	$"../GPUParticles2D".emitting = false
	$"../GPUParticles2D2".emitting = false
	$"../GPUParticles2D3".emitting = false
	await get_tree().create_timer(1).timeout
	$"..".hide()
	self.hide()
	can_expand = true
	$"../Kill_Timer".stop()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and domain_expanding:
		area.die()


func _on_kill_timer_timeout() -> void:
	if domain_expanding:
		var bodies = $"../Area2D".get_overlapping_bodies()
		for i in bodies:
			if i.is_in_group("enemy"):
				i.die()
		$"../Kill_Timer".start(0.1)
