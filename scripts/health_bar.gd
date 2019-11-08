extends Control

onready var health_bar = $health_bar
onready var character = get_owner()

func _ready():
	#health_bar.value = 100
	character.connect("health_updated", self, "_on_health_updated")
	pass
func _on_health_updated(health):
	health_bar.value = health
	#$Tween.interpolate_property(health_bar, "value", health_bar.value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#$Tween.start()

func _max_health(max_health):
	health_bar.value = max_health
	
