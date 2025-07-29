extends Area2D

func _on_body_entered(body: Node2D) -> void:
	#if(body.name == "player"):
		#print("CONTRATS YOU WON")
	print("CONTRATS YOU WON")
	var finish_screens = get_tree().get_nodes_in_group("finish_screen")	#wywołuje finish_screen
	if finish_screens.size() > 0:
		finish_screens[0].finish_screen()
