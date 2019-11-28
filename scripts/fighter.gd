extends "KinematicBody2D.gd"

func _ready():
	add_to_group("player")
	#get_owner().connect("attack", self, damage)

func _process(delta):
	motion.y += GRAVITY
	if movement:
		input_p1()
	
	if _is_hit():
		damage(2)
		#print(health)
	#$effects.stop()
	pass

	

