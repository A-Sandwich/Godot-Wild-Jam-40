extends KinematicBody2D

var is_moving = false
var starting_position = Vector2.ZERO
var destination_position = Vector2.ZERO
var grid_size = 16
var movement_speed = 100
var movement_direction = Vector2.ZERO



func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	process_input()
	choose_animation()
	move(delta)

func move(delta):
	if global_position.distance_to(destination_position) < 1:
		global_position = destination_position
		is_moving = false
		return
	print(global_position)
	var collision = move_and_collide(movement_direction * movement_speed * delta)
	if collision:
		print("collission")
		movement_direction *= -1
		destination_position = starting_position
	

func process_input():
	if is_moving:
		return

	movement_direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		movement_direction.x = 1
	elif Input.is_action_pressed("move_left"):
		movement_direction.x = -1
	elif Input.is_action_pressed("move_up"):
		movement_direction.y = -1
	elif Input.is_action_pressed("move_down"):
		movement_direction.y = 1
	if movement_direction != Vector2.ZERO:
		is_moving = true
		starting_position = global_position
		destination_position = global_position + (movement_direction * grid_size)
		print(global_position, destination_position)

func choose_animation():
	if $AnimatedSprite.playing and not is_moving:
		$AnimatedSprite.stop()
	
	if is_moving:
		if movement_direction.x == 1:
			$AnimatedSprite.flip_h = false
			if not $AnimatedSprite.animation != "walk":
				$AnimatedSprite.play("walk")
		elif movement_direction.x == -1:
			$AnimatedSprite.flip_h = true
			if not $AnimatedSprite.animation != "walk":
				$AnimatedSprite.play("walk")
		elif not $AnimatedSprite.animation != "walk":
			$AnimatedSprite.play("walk")
		
