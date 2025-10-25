extends Area2D
var damage : int

const DAMAGE_INDICATOR = preload("uid://drucr8c11yv4b")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var ind = DAMAGE_INDICATOR.instantiate()
		get_parent().add_child(ind)
		ind.position = global_position
		
		area.hit(damage)
