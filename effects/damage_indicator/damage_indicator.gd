extends Label

var damage = 1
var damage_color

const LIGHT_DAMAGE = Color(1.0, 0.996, 1.0, 1.0)
const MEDIUM_DAMAGE = Color(0.969, 0.965, 0.533, 1.0)
const BIG_DAMAGE = Color(0.427, 0.902, 0.906, 1.0)
const HEAVY_DAMAGE = Color(0.91, 0.749, 0.886, 1.0)
const EXTREME_DAMAGE = Color(0.847, 0.094, 0.043, 1.0)

var damages = [LIGHT_DAMAGE,LIGHT_DAMAGE,MEDIUM_DAMAGE,BIG_DAMAGE,HEAVY_DAMAGE,EXTREME_DAMAGE]

func _ready() -> void:
	damage_color = damages[int(lerp(0,len(damages),damage/100))]

func _process(delta: float) -> void: 
	text = str(damage)
	modulate = lerp(modulate, Color(damage_color.r,damage_color.g,damage_color.b,0), delta * 5)


func _on_timer_timeout() -> void: queue_free()
