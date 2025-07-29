extends CharacterBody2D

@onready var ray_cast_right_bottom: RayCast2D = $RayCastRightBottom
@onready var ray_cast_left_bottom: RayCast2D = $RayCastLeftBottom
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft


const SPEED = 30
var current_state = IDLE

var direction = Vector2.RIGHT
var start_position

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum  {
	IDLE,
	NEW_DIRECTION,
	MOVE
}

func _ready() -> void:
	randomize()
	start_position = position
	
func _process(delta: float) -> void:
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
		if direction.x == -1:
			$AnimatedSprite2D.play("walking_left")
		if direction.x == 1:
			$AnimatedSprite2D.play("walking_right")
			
	#JESLI KOLIDUJE Z DWOCH STRON TO NPC ZATRZYMUJE SIE I PRZECHODZI NA IDLE
	if ray_cast_left.is_colliding() and ray_cast_right.is_colliding():
		current_state = IDLE
		return
		
	#OBROT JESLI NAPOTKA SCIANE LUB BRAK PODLOKI PRZED NIM
	if direction == Vector2.RIGHT && (!ray_cast_right_bottom.is_colliding() || ray_cast_right.is_colliding()):
		direction = Vector2.LEFT
	if direction == Vector2.LEFT && (!ray_cast_left_bottom.is_colliding() || ray_cast_left.is_colliding()):
		direction = Vector2.RIGHT
	
		
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIRECTION:
				direction = choose([Vector2.RIGHT, Vector2.LEFT])
			MOVE:
				move(delta)
	if Input.is_action_just_pressed("chat"):
		print("chatting with NPC")
		$Dialogue.start()
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")
				
func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += direction * SPEED * delta


func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat_zone = false

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIRECTION, MOVE])


func _on_dialogue_dialogue_finished() -> void:
	is_chatting = false
	is_roaming = true
