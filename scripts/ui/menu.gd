extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/wybor_poziomu.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/options_menu.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()
