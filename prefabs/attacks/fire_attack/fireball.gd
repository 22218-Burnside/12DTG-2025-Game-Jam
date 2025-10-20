extends Area2D
var damage : int


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		if area.vulnerable:
			area.health -= damage * 2
		else:
			area.health -= damage
		if area.health <= 0:
			area.die()
