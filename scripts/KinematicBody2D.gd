extends KinematicBody2D

#get_tree().add_to_group("players")

signal health_updated(health)
signal killed()

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
var die = false

func _ready():
	emit_signal("health_updated", health)

func input_p1():
	#$sprite_col.disabled = false
	var friction = false
	if Input.is_action_pressed("ui_right"):
		
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$sprite.flip_h = false
		$hitbox.scale.x = 1
		$anim_player.play("run", 1, 4)
	
	elif Input.is_action_pressed("ui_left"):
		
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$sprite.flip_h = true
		$hitbox.scale.x = -1
		$anim_player.play("run", 1, 2)
	
	elif Input.is_action_just_pressed("attack1"):
			attacking = true
			#motion.x = 1000
			$anim_player.play("attack")
			yield($anim_player, "animation_finished")
			#attack()
			friction = true
			
	
	elif Input.is_action_pressed("attack2"):
		attacking = true
		$anim_player.play("attack2", 1, 8)
		friction = true
	
	elif Input.is_action_just_pressed("dash"):
		if $sprite.flip_h:
			motion.x = -1000
		else:
			motion.x = 1000
		
		$anim_player.play("dash")
		
		
	else:
	#elif Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right") || Input.is_action_just_released("attack") || !jumping:
		$anim_player.play("idle")
		friction = true
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			jumping = true
		if friction:
			motion.x = lerp(motion.x, 0, 0.2)
	
	else:
		if motion.y != 0:
			if !die:
				$anim_player.play("jump")
			else:
				$anim_player.play("die")
				$sprite_col.disabled = true
		else:
			jumping = false
		motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide(motion, UP)

func input_p2():
	var friction = false
	if Input.is_action_pressed("p2_right"):
		
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$sprite.flip_h = false
		$hitbox.scale.x = 1
		$anim_player.play("run", 1, 4)
	
	elif Input.is_action_pressed("p2_left"):
		
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$sprite.flip_h = true
		$hitbox.scale.x = -1
		$anim_player.play("run", 1, 2)
	
	elif Input.is_action_pressed("p2_attack1"):
		attacking = true
		$anim_player.play("attack", 1, 8)
		friction = true
	
	elif Input.is_action_pressed("p2_attack2"):
		attacking = true
		$anim_player.play("attack2", 1, 8)
		friction = true
	
	elif Input.is_action_just_pressed("p2_dash"):
		if $sprite.flip_h:
			motion.x = -1000
		else:
			motion.x = 1000
		
		$anim_player.play("dash")
		
		
	else:
	#elif Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right") || Input.is_action_just_released("attack") || !jumping:
		$anim_player.play("idle")
		friction = true
		
	if is_on_floor():
		if Input.is_action_just_pressed("p2_up"):
			motion.y = JUMP_HEIGHT
			jumping = true
		if friction:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if motion.y != 0:
			if !die:
				$anim_player.play("jump")
			else:
				$anim_player.play("die")
				$sprite_col.disabled = true
		else:
			jumping = false
		motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide(motion, UP)

func kill():
	#$sprite.visible = false
	die = true
	motion.y = -300
	#$sprite_col.disabled = true
	pass

func attack():
	$anim_player.current_animation = "attack1"
	yield($anim_player, "animation_finished")

func damage(amount):
	_set_health(health - amount)
	$effects.play("damage")
	#$effects.stop()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0 , max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

func _is_hit():
	var areas = $hurtbox.get_overlapping_areas()
	for area in areas:
		#print(area.name)
		if area.name != "hurtbox":
			return true
	

