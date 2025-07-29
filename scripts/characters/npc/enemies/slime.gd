extends CharacterBody2D

const SPEED = 40

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right_bottom: RayCast2D = $RayCastRightBottom
@onready var ray_cast_left_bottom: RayCast2D = $RayCastLeftBottom
@onready var slime: CharacterBody2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if !ray_cast_right_bottom.is_colliding() || ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false
	if !ray_cast_left_bottom.is_colliding() || ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true
	position.x += direction * SPEED * delta


func _on_slime_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
