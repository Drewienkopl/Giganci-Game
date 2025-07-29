extends Area2D

@export var link_code: int = 0
@export var target_door: StaticBody2D


signal pressed(new_state: bool)
signal released(new_state: bool)

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var CollisionPolygon: CollisionPolygon2D = get_node("CollisionPolygon2D")

func _ready() -> void:	
	animation_player.play("NotPressed")
	
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	
	
	

# Sprawdza czy obiekt który wchodzi/opuszcza płytke jest w grupie Pushable

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Pushable"):
		animation_player.play("Pressed")
		if link_code == target_door.link_code:
			pressed.emit(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Pushable"):
		animation_player.play("NotPressed")
		if link_code == target_door.link_code:
			released.emit(false)
