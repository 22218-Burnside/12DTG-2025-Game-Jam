extends Control

const Main_Menu = "res://testing/new_map.tscn"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file(Main_Menu)
