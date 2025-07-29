extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const JUMP_VELOCITY = -300.0
const ACCELERATION = 200
const MAX_SPEED = 145.0
const FRICTION = 500
const DASH = 260.0
const PUSH_FORCE = 80.0
const MAX_PUSH_SPEED = 50.0

var direction = 0
var dash_cooldown: bool = false
var is_dashing = false
var is_dead: bool = false
var dash_duration = 0.5
var dash_timer = 0.0
var pushable_object: RigidBody2D = null

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	
	if not is_dead:
		if direction < 0:
			animated_sprite.flip_h = true
		if direction > 0:
			animated_sprite.flip_h = false
	if not is_dead:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")	
		
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			dash_cooldown = true
			$DashCooldown.start()
			velocity.x = 0
	else:
		if direction and Input.is_action_just_pressed("dash"):
			if not dash_cooldown:
				velocity.x = direction * DASH
				is_dashing = true
				dash_timer = dash_duration
		elif direction:
			velocity.x = move_toward(velocity.x, MAX_SPEED*direction, (ACCELERATION * delta))
		else:
			velocity.x = move_toward(velocity.x, 0, (FRICTION * delta))
	
	if not is_dead:
		move_and_slide()
	
	# Przepychanie obiektów
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D and c.get_collider().is_in_group("Pushable"):
			var collider = c.get_collider()
			var current_velocity = collider.get_linear_velocity()
			var push_direction = -c.get_normal() * PUSH_FORCE
			
			var new_velocity = current_velocity + push_direction / collider.get_mass() * get_process_delta_time()
			
			if new_velocity.length() > MAX_PUSH_SPEED:
				push_direction = push_direction.normalized() * MAX_PUSH_SPEED - current_velocity
				collider.apply_central_impulse(push_direction)
			else:
				collider.apply_central_impulse(push_direction)

func _on_dash_cooldown_timeout() -> void:
	dash_cooldown = false
	
func die() -> void:
	#if not is_dead:
	#	return
	
	#print("Player Died!")
	#is_dead = true
	#velocity = Vector2.ZERO

	# Optional: Play death animation
	#if animated_sprite.has_animation("death"):
		animated_sprite.play("death")
		await animated_sprite.animation_finished
	#else:
		# If no death animation, just hide the sprite
		#animated_sprite.hide()

	#get_tree().change_scene_to_file("res://scenes/ui/game_over_screen.tscn")
