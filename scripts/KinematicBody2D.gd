extends KinematicBody2D

#get_tree().add_to_group("players")

signal health_updated(health)
signal killed()
#signal attack(amount)

var motion = Vector2()
var attacking = false
var jumping = false


const UP = Vector2(0, -1)
const GRAVITY = 20

export (int) var ACCELERATION = 20
export (int) var MAX_SPEED = 250
export (int) var JUMP_HEIGHT = -550
export (float) var max_health = 100
export (bool) var movement = true

onready var health = max_health setget _set_health
onready var animator = $anim_player

var die = false

func _ready():
	emit_signal("health_updated", health)

################################### INPUT 1 ##############################################

func input_p1():
	
	#$sprite_col.disabled = false
	var friction = false
	if Input.is_action_pressed("ui_right") && !attacking:
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$sprite.flip_h = false
		$hitbox.scale.x = 1
		animator.play("run", 1, 4)
	
	elif Input.is_action_pressed("ui_left") && !attacking:
		
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$sprite.flip_h = true
		$hitbox.scale.x = -1
		animator.play("run", 1, 2)
	
	elif Input.is_action_just_pressed("attack1") && !attacking && !jumping:
		attacking = true
		friction = true
		animator.play("attack", 1, 2)
		yield(animator, "animation_finished")
		attacking = false
	
	elif Input.is_action_just_pressed("attack2") && !attacking && !jumping:
		attacking = true
		friction = true
		animator.play("attack2", 1, 3)
		yield(animator, "animation_finished")
		attacking = false
		
	
	elif Input.is_action_just_pressed("dash") && !attacking:
		dash()
		#yield(animator, "animation_finished")
		
	elif !attacking:
	#elif Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right") || Input.is_action_just_released("attack") || !jumping:
		animator.play("idle")
		friction = true
		
	if is_on_floor():
		jumping = false
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			jumping = true
		if friction:
			motion.x = lerp(motion.x, 0, 0.2)
		
	else:
		jumping = true
		attacking = false
		if motion.y != 0:
			if !die:
				animator.play("jump")
			else:
				animator.play("die")
				$sprite_col.disabled = true
		else:
			jumping = false
		motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide(motion, UP)

################################### INPUT 2 ##############################################

func input_p2():
	
	#$sprite_col.disabled = false
	var friction = false
	if Input.is_action_pressed("p2_right") && !attacking:
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$sprite.flip_h = false
		$hitbox.scale.x = 1
		animator.play("run", 1, 4)
	
	elif Input.is_action_pressed("p2_left") && !attacking:
		
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$sprite.flip_h = true
		$hitbox.scale.x = -1
		animator.play("run", 1, 2)
	
	elif Input.is_action_just_pressed("p2_attack1") && !attacking && !jumping:
		attacking = true
		friction = true
		animator.play("attack", 1, 2)
		yield(animator, "animation_finished")
		attacking = false
	
	elif Input.is_action_just_pressed("p2_attack2") && !attacking && !jumping:
		attacking = true
		friction = true
		animator.play("attack2", 1, 3)
		yield(animator, "animation_finished")
		attacking = false
		
	
	elif Input.is_action_just_pressed("p2_dash") && !attacking:
		dash()
	
	elif !attacking:
	#elif Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right") || Input.is_action_just_released("attack") || !jumping:
		animator.play("idle")
		friction = true
		
	if is_on_floor():
		jumping = false
		if Input.is_action_just_pressed("p2_up"):
			motion.y = JUMP_HEIGHT
			jumping = true
		if friction:
			motion.x = lerp(motion.x, 0, 0.2)
		
	else:
		jumping = true
		attacking = false
		if motion.y != 0:
			if !die:
				animator.play("jump")
			else:
				animator.play("die")
				$sprite_col.disabled = true
		else:
			jumping = false
		motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide(motion, UP)

##################################### KILL ###############################################

func kill():
	#$sprite.visible = false
	die = true
	motion.y = -300
	#$sprite_col.disabled = true
	pass

#################################### DAMAGE ##############################################

func damage(amount):
	_set_health(health - amount)
	$effects.play("damage")
	animator.play("die")
	attacking = false

################################## SET HEALTH ############################################
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0 , max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

#################################### IS HIT ##############################################

func _is_hit():
	var areas = $hurtbox.get_overlapping_areas()
	for area in areas:
		#print(area.name)
		if area.name != "hurtbox":
			return true

func dash():
	if $sprite.flip_h:
		motion.x = -1000
	else:
		motion.x = 1000
	animator.play("dash")

