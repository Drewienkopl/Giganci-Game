extends Control
@onready var pucharek_showcase_level: TextureRect = $"Whole Test/Test Level/Level Test Panel/Pucharek_showcase_level"
@onready var pucharek_level_1: TextureRect = $"Whole Level 1/Test Level/Level 2 Panel/Pucharek_level1"
@onready var pucharek_level_2: TextureRect = $"Whole Level 2/Test Level/Level 2 Panel/Pucharek_level2"

func _ready():
	load_level_trophys()

func load_level_trophys():
	var save_path = "user://progress.cfg"
	var config = ConfigFile.new()
	if config.load(save_path) != OK:
		print("Brak pliku zapisu")
		return
		
	var trophy_map = {
		"showcase_level": pucharek_showcase_level,
		"level1": pucharek_level_1,
		"level2": pucharek_level_2,
	}
		
	for level_name in trophy_map.keys():
		var trophy = config.get_value(level_name, "trophy", "")
		if trophy:
			var trophy_icon = trophy_map[level_name]
			match trophy:
				"gold":
					trophy_icon.texture = preload("res://assets/sprites/Trophys/gold_trophy.png")
				"silver":
					trophy_icon.texture = preload("res://assets/sprites/Trophys/silver_trophy.png")
				"bronze":
					trophy_icon.texture = preload("res://assets/sprites/Trophys/bronze_trophy.png")
			

func _on_play_test_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/showcase_level.tscn")


func _on_play_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")


func _on_play_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level2.tscn")

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
