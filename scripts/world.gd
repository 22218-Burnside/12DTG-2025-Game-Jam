extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$level_ui.hide()
	$menu.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func player_hit(damage):
	$player.health -= damage
	$level_ui/ProgressBar.value = $player.health
	if $player.health <= 0:
		$player.controlling = false
		$menu/Label.show()
		$menu.show()
		$level_ui.hide()


func _on_enemy_enemy_hit_player(damage) -> void:
	player_hit(damage)


func _on_play_pressed() -> void:
	$menu.hide()
	$level_ui.show()
	$player.setup()
