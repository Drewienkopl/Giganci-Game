extends AnimatedSprite2D

var is_down = false
var last_enabled_group := -1  # identyfikator ostatnio aktywnej grupy klatek

#grupy klatek o wspólnej kolizji
const COLLISION_GROUPS := {
	0: [0, 1],
	1: [2, 3, 8, 9],
	2: [4, 5, 6, 7],
	3: [10, 11]
}

#Mapowanie klatek na identyfikator grupy
var frame_to_group := {}

func _ready() -> void:
	self.play("grow")
	
	# Zbuduj mapę z klatki do grupy (odwrotność COLLISION_GROUPS)
	for group_id in COLLISION_GROUPS.keys():
		for frame in COLLISION_GROUPS[group_id]:
			frame_to_group[frame] = group_id

#zmienia kolizje kolcy dla każdej grupy innych klatek
func _on_frame_changed() -> void:
	var current_frame = frame
	if not frame_to_group.has(current_frame):
		print("Brak zdefiniowanej grupy kolizji dla klatki:", current_frame)
		return

	var new_group = frame_to_group[current_frame]

	#Jeżeli grupa się nie zmieniła, nie zmieniaj kolizji
	if new_group == last_enabled_group:
		return

	#Czy na pewno wszystkie kolizje są wyłączone
	for i in range(12):
		var col = get_node("KillZone/KolizjaKolcyKlatka" + str(i))
		if col: col.disabled = true

	#Włącz tylko kolizje z nowej grupy
	for i in COLLISION_GROUPS[new_group]:
		var col = get_node("KillZone/KolizjaKolcyKlatka" + str(i))
		if col: col.disabled = false

	last_enabled_group = new_group
