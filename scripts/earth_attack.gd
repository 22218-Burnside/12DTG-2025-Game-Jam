extends Area2D

var level : int

func _ready() -> void:
	$Timer.start(5)

func _physics_process(_delta: float) -> void:
	for i in get_overlapping_areas():
		if i.is_in_group("enemy"):
			i.vulnerable = true


func _on_timer_timeout() -> void:
	self.queue_free()


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.vulnerable = false
