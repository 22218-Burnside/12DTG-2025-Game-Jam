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
		if key_char == domain_sequence[domain_progress]:
			domain_progress += 1
			if domain_progress == domain_sequence.length() and can_expand:
				# Full sequence successful!
				$"..".show()
				$"../anukus".play()
				$"../GPUParticles2D".emitting = true
				$"../GPUParticles2D2".emitting = true
				$"../Timer".start(15)
				$"../Icon".hide()
				$"../../Camera2D".shake(10.0,15.0)
				self.show()
				domain_expanding = true
				domain_progress = 0 # Reset for next time
				can_expand = false
		else:
			# Reset on wrong key or partial input error
			domain_progress = 0

func _physics_process(_delta: float) -> void:
	if domain_expanding:
		var areas = $"../Area2D".get_overlapping_areas()
		for i in areas:
			if i.is_in_group("enemy"):
				i.die()

func _on_timer_timeout() -> void:
	domain_expanding = false
	$"../anukus".stop()
	$"../GPUParticles2D".emitting = false
	$"../GPUParticles2D2".emitting = false
	await get_tree().create_timer(1).timeout
	$"..".hide()
	self.hide()
	can_expand = true


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and domain_expanding:
		area.die()
