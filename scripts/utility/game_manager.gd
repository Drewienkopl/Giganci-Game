extends Node

var score = 0
var lives = 5

@onready var coins_label: Label = $"../GUI/CollectedCoins/HBoxContainer/coinsLabel"
@onready var kill_zone_nodes = get_tree().get_nodes_in_group("kill_zone")
@onready var kill_zone: Node = kill_zone_nodes[0] if kill_zone_nodes.size() > 0 else null
@export var hearts : Array[Node]

func _ready():
	add_to_group("game_manager")
	hearts = [get_node("../GUI/Health/Hearts/Heart1"), get_node("../GUI/Health/Hearts/Heart2"), get_node("../GUI/Health/Hearts/Heart3"), get_node("../GUI/Health/Hearts/Heart4"), get_node("../GUI/Health/Hearts/Heart5")]
		
	for h in hearts:#upewnia sie ze serca sa przypisane
		if h == null:
			print("Błąd: jedno z serc jest null!",h )
			return

func decrease_health(body):
	if lives <= 0:
		return  #Juz nie zyje
		
	if body.global_position.y > 100:
		lives = 0
	else:
		lives -= 1
	print(lives)
	
	for i in range(5):  #Pętla dla każdego serca
		if i < lives:
			hearts[i].show()  #Pokaż serce, jeśli gracz ma jeszcze życie
		else:
			hearts[i].hide()  #Ukryj serce, jeśli gracz nie ma już tego życia

	if not kill_zone:   #Pobierz KillZone jeśli nie został wcześniej znaleziony
		var kill_zone_nodes = get_tree().get_nodes_in_group("kill_zone")
		kill_zone = kill_zone_nodes[0] if kill_zone_nodes.size() > 0 else null
	
	if(lives == 0):
		if kill_zone:  # Sprawdzenie, czy kill_zone nie jest null
			kill_zone.player_dead(body)
		else:
			print("Błąd: kill_zone nie został znaleziony!")
			kill_zone.player_dead(body)  # Wywołanie player_dead z kill_zone

func add_point():
	score += 1
	print(score)
	coins_label.text = str(score)
