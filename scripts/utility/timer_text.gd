extends Label

#@onready var timer_text: Label = $"."
#@onready var dash_cooldown: Timer = get_node("/root/Game/Player/DashCooldown")

#func _process(delta):
	#timer_text.set_text("Cooldown dasha: " + str(round(dash_cooldown.get_time_left())))
