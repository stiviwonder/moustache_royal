extends RigidBody2D

var motion = Vector2()
const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 20
const MAX_SPEED = 250
const JUMP_HEIGHT = -550


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var flip = $sprite.flip_h
	if Input.is_action_pressed("ui_right"):
		
		$sprite.play("run")
		flip = false
		
	elif Input.is_action_pressed("ui_left"):
		
		
		flip = true
		$sprite.play("run")
	
	else:
		$sprite.play("idle")
		friction = true
	
	
	pass
