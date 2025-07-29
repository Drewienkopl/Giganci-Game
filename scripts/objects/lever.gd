extends Area2D

@export var link_code: int = 0
@export var activation_key: String = "e" # Klawisz aktywujący dźwignię
@export var target_door: StaticBody2D  
signal lever_turned(new_state: bool)

const TEXTURES: Dictionary = {
	'right': preload("res://assets/sprites/Lever/lever_right.png"),
	'left': preload("res://assets/sprites/Lever/lever_left.png")
}

var facing: int = 1  # 1 = right, -1 = left
var player_nearby: bool = false  # Czy gracz jest w pobliżu?

@onready var sprite: Sprite2D = get_node("Sprite2D")

func _ready() -> void:
	pass

func _input(event):
	if player_nearby and event is InputEventKey and event.pressed and event.keycode == KEY_E:
		toggle()

func toggle():
	facing *= -1  # Zmiana kierunku
	sprite.texture = TEXTURES['right'] if facing == 1 else TEXTURES['left']
	if facing == 1:
		lever_turned.emit(true)
	else:
		lever_turned.emit(false)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
