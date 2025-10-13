extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func player_hit(damage):
	$player.health -= 10
	$level_UI/ProgressBar.value = $player.health


func _on_enemy_enemy_hit_player(damage) -> void:
	player_hit(damage)
