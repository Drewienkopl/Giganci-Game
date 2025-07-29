extends Area2D

@onready var timer: Timer = $Timer
@onready var damage_timer: Timer = $DamageTimer
@onready var game_manager: Node = get_tree().get_nodes_in_group("game_manager")[0]
@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]

var bodies_in_zone = []

func _ready():
	add_to_group("kill_zone")
	damage_timer.one_shot = false  # Timer działa w pętli

#do zycia
func player_dead(body):
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return  # ignoruj wszystko poza graczem
		
	if body not in bodies_in_zone:
		bodies_in_zone.append(body)
	

	if damage_timer.is_stopped(): # Uruchamiamy DamegeTimer jeśli był wcześniej zatrzymany
		print("lives -1!")
		game_manager.decrease_health(body)  # Odejmowanie życia
		damage_timer.start()
	
func _on_body_exited(body: Node2D) -> void:
	if body in bodies_in_zone:
		bodies_in_zone.erase(body)
	
	if bodies_in_zone.is_empty():
		damage_timer.stop() # Jeśli nie ma graczy w KillZone, zatrzymujemy timer
		
func _on_damage_timer_timeout() -> void:
	# Sprawdzamy, czy nadal są obiekty w KillZone przed zadaniem obrażeń
	if bodies_in_zone.is_empty():
		damage_timer.stop()  
		return
	
	# Upewniamy się, że odwołujemy się tylko do istniejących obiektów
	for body in bodies_in_zone.duplicate():  # Kopiujemy listę, aby uniknąć błędów usunięcia
		if is_instance_valid(body):  # Sprawdzamy, czy obiekt nadal istnieje
			game_manager.decrease_health(body)
			print("Wszedł obiekt:", body.name)
		else:
			bodies_in_zone.erase(body)  # Usuwamy nieprawidłowe instancje

func _on_timer_timeout() -> void:
	Engine.time_scale = 1 
	var game_over_screens = get_tree().get_nodes_in_group("game_over_screen")	#wywołuje game_over_screen
	if game_over_screens.size() > 0:
		game_over_screens[0].dead_screen()

	
