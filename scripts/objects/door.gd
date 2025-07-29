extends StaticBody2D

@export var link_code: int = 0
@export var target_interactable: Area2D

var is_open: bool = false


@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
@onready var sprite_animation: AnimationPlayer = get_node("SpriteAnimation")


func _ready() -> void:	
	#collision_shape.disabled = false
	sprite_animation.play("Idle")
	
	
	if target_interactable.is_in_group("Pressure_plate"):
		if link_code == target_interactable.link_code:
			target_interactable.pressed.connect(_on_pressure_plate_pressed)
			target_interactable.released.connect(_on_pressure_plate_released)
	elif target_interactable.is_in_group("Lever"):
		if link_code == target_interactable.link_code:
			target_interactable.lever_turned.connect(_on_lever_turned)




func _on_pressure_plate_pressed(_new_state: bool) -> void:
	if link_code != 0 and link_code == target_interactable.link_code:
			is_open = _new_state
			if is_open:
				sprite_animation.play("Open")
				change_colission_box_position_to_open()
				print("Playing open animation")


func _on_pressure_plate_released(_new_state: bool) -> void:
	if link_code != 0 and link_code == target_interactable.link_code:
			is_open = _new_state
			if not is_open:
				sprite_animation.play_backwards("Open")
				change_collision_box_position_to_closed()
				print("playing close animation")
				
func _on_lever_turned(_new_state: bool) -> void:
	is_open = _new_state
	if not is_open:
		sprite_animation.play("Open")
		change_colission_box_position_to_open()
		print("playing open animation")
	else:
		sprite_animation.play_backwards("Open")
		change_collision_box_position_to_closed()
		print("playing close animation")
		
				
func change_colission_box_position_to_open() -> void:
	var SizeVector = Vector2(21.0,6.0)
	var PositionVector = Vector2(0.5,-21.0)
	
	collision_shape.position = PositionVector
	collision_shape.shape.size = SizeVector
	
func change_collision_box_position_to_closed() -> void:
	var SizeVector = Vector2(31.0,48.0)
	var PositionVector = Vector2(0.5,0)
	
	collision_shape.position = PositionVector
	collision_shape.shape.size = SizeVector
	
