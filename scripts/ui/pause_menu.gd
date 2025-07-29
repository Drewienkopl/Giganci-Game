extends Control

var pause_screen_on: bool = false

func _ready():
	$AnimationPlayer.play("RESET")
	hide()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide()
	pause_screen_on = false
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show()
	pause_screen_on = true
	
func testEsc():
	if Input.is_action_just_pressed("escape") and !get_tree().paused and !pause_screen_on:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused and pause_screen_on:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

func _process(delta: float) -> void:
	testEsc()
