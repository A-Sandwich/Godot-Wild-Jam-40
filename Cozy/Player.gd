extends KinematicBody2D

var is_moving = false
var starting_position = Vector2(8, 8)
var destination_position = Vector2(24, 8)
var offset = Vector2(8, 8)
var grid_size = 16
var movement_speed = 100
var movement_direction = Vector2.ZERO


func _ready():
	pass


func _physics_process(delta):
	process_input()
	choose_animation()
	move(delta)

func move(delta):
	if (global_position + offset).distance_to(destination_position) < 1:
		global_position = destination_position - offset
		is_moving = false
		return

	var collision = move_and_collide(movement_direction * movement_speed * delta)
	if collision:
		movement_direction *= -1
		destination_position = starting_position
	

func process_input():
	if is_moving:
		return

	if Input.is_action_just_pressed("action_button"):
		$AnimatedSprite.play("axe")
		return
	if Input.is_action_just_released("action_button"):
		$AnimatedSprite.stop()
	
	if $AnimatedSprite.is_playing() and $AnimatedSprite.animation == "axe":
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
		var original_position = global_position
		starting_position = global_position + offset
		destination_position = starting_position + (movement_direction * grid_size)
		print("start", starting_position, "dest", destination_position, movement_direction * grid_size)
		update()
		get_parent().get_node("circle").global_position = destination_position
		if is_position_invalid():
			destination_position = original_position
			is_moving = false
			movement_direction = Vector2.ZERO
			print("Position invalid")
			return
		else:
			is_moving = true

func _draw():
	print("drawing", starting_position, destination_position)
	draw_line(to_local(starting_position), to_local(destination_position), Color(1, 1, 0))

func is_position_invalid():
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	print(starting_position, destination_position, "is_invalid?")
	var result = space_state.intersect_ray(starting_position, destination_position, [self, $CollisionShape2D], 1)
	if result.empty():
		print("valid")
	else:
		print("invalid")
	return !result.empty()

func choose_animation():
	if $AnimatedSprite.playing and not is_moving and $AnimatedSprite.animation == "walk":
		$AnimatedSprite.stop()
	
	if is_moving:
		if movement_direction.x == 1:
			$AnimatedSprite.flip_h = false
			if not $AnimatedSprite.animation != "walk" or not $AnimatedSprite.is_playing():
				$AnimatedSprite.play("walk")
		elif movement_direction.x == -1:
			$AnimatedSprite.flip_h = true
			if not $AnimatedSprite.animation != "walk" or not $AnimatedSprite.is_playing():
				$AnimatedSprite.play("walk")
		elif not $AnimatedSprite.animation != "walk" or not $AnimatedSprite.is_playing():
			$AnimatedSprite.play("walk")
		
