extends Control

@onready var score_timer: Timer = $"../../ScoreTimer"
@onready var print_score_timer: Timer = $"../../ScoreTimer/PrintScoreTimer"

@onready var trophy_1: TextureRect = $PanelContainer/NinePatchRect/Trophy1
@onready var trophy_2: TextureRect = $PanelContainer/NinePatchRect/Trophy2
@onready var trophy_3: TextureRect = $PanelContainer/NinePatchRect/Trophy3

var trophy_time_for_levels = {
	"showcase_level": {"gold": 35.0, "silver": 50.0, "bronze": 70.0},
	"level1": {"gold": 27.0, "silver": 35.0, "bronze": 50.0},
	"level2": {"gold": 40.0, "silver": 55.0, "bronze": 70.0},	
}

func _ready():
	add_to_group("finish_screen") #dla finish, aby widział finish_screen
	$AnimationPlayer.play("RESET")
	hide()
	
	score_timer.wait_time = 120.0 #Timer do odliczania czasu
	score_timer.autostart = true
	score_timer.one_shot = true
	score_timer.start()
		
	print_score_timer.wait_time = 1.0 #timer do printowania co 1 sek
	print_score_timer.autostart = true
	print_score_timer.one_shot = false
	print_score_timer.start()
	
func _on_print_score_timer_timeout() -> void: #printuje elapsed time
	var elapsed_time = score_timer.wait_time - score_timer.time_left
	print("Elapsed time: ", elapsed_time, " sekund")
	
func show_trophy():
	var elapsed_time = score_timer.wait_time - score_timer.time_left
	
	# Ukrywamy wszystkie trofea na start
	trophy_1.visible = false
	trophy_2.visible = false
	trophy_3.visible = false
	
	var path = get_tree().current_scene.scene_file_path
	var current_level = path.get_file().get_basename()
	
	if !trophy_time_for_levels.has(current_level):
		print("Brak progów czasowych dla tego levela")
		print("Aktualna scena: ", current_level)
		return
	
	var treshholds = trophy_time_for_levels[current_level]
	
	#jaki pucharek na czasy
	var trophy = ""
	if elapsed_time <= treshholds["gold"]:
		trophy_1.visible = true  # Najlepszy czas
		trophy = "gold"
	elif elapsed_time <= treshholds["silver"]:
		trophy_2.visible = true  # Średni czas
		trophy = "silver"
	elif elapsed_time <= treshholds["bronze"]:
		trophy_3.visible = true  # Najgorszy czas
		trophy = "bronze"
		
	save_best_score(current_level, elapsed_time, trophy)

func save_best_score(level_name: String, time: float, trophy: String):
	var save_path = "user://progress.cfg"
	var config = ConfigFile.new()
	var err = config.load(save_path)
	
	if err != OK:
		print("Tworze nowy plik zapisu")
		
	var	best_time = config.get_value(level_name, "best_time", -1.0)
	
	if best_time < 0 or time < float(best_time):
		config.set_value(level_name, "best_time", time)
		config.set_value(level_name, "trophy", trophy)
		print("Zapisano nowy rekord :", time, "i pucharek: ", trophy)
	else:
		print("Nie pobito rekordu")
		
	config.save(save_path)

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide()
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show()
	
func finish_screen():
	if !get_tree().paused:
		pause()
	show_trophy()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()
	

func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")


func _on_next_level_pressed() -> void:
	resume()
	
	var current_scene_path = get_tree().current_scene.scene_file_path
	
	if current_scene_path == "res://scenes/levels/showcase_level.tscn":
		get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
	elif current_scene_path == "res://scenes/levels/level1.tscn":
		get_tree().change_scene_to_file("res://scenes/levels/level2.tscn")
	elif current_scene_path == "res://scenes/levels/level2.tscn":
		get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
	else:
		print("Błąd!!! Nieznana scena..")
