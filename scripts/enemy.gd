extends "KinematicBody2D.gd"

func _ready():
	add_to_group("player")


func _process(delta):
	
	motion.y += GRAVITY
	if movement:
		input_p2()
	
	if _is_hit():
		damage(10)
		#print(health)
	#$effects.stop()
	pass

	

