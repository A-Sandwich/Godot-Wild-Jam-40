extends KinematicBody2D

var is_moving = false
var starting_position = Vector2(8, 8)
var destination_position = Vector2(24, 8)
var offset = Vector2(8, 8)
var grid_size = 16
var movement_speed = 100
var movement_direction = Vector2.ZERO
var last_direction_moved = Vector2.ZERO


func _ready():
	pass

func _physics_process(delta):
	process_input(delta)
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
	

func process_input(delta):
	if is_moving:
		return

	if Input.is_action_just_pressed("action_button"):
		$AnimatedSprite.play("axe")
		chop_tree(0)
		return

	# I feel like this could cause a bug
	if Input.is_action_pressed("action_button"):
		chop_tree(delta)
	
	if Input.is_action_just_released("action_button"):
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = "walk"
	
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
		var original_position = populate_target_destination()
		update()
		if is_position_invalid():
			destination_position = original_position
			is_moving = false
			movement_direction = Vector2.ZERO
			print("Position invalid")
			return
		else:
			is_moving = true
			last_direction_moved = movement_direction

func _draw():
	print("drawing", starting_position, destination_position)
	draw_line(to_local(starting_position), to_local(destination_position), Color(1, 1, 0))

func is_position_invalid():
	var result = check_destination()
	if result.empty():
		print("valid")
	else:
		print("invalid")
	return !result.empty()

func populate_target_destination():
	var original_position = global_position
	var move_vector = movement_direction if movement_direction != Vector2.ZERO else last_direction_moved
	starting_position = global_position + offset
	destination_position = starting_position + (move_vector * grid_size)
	print("start", starting_position, "dest", destination_position, move_vector * grid_size)
	return original_position
	
func check_destination():
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var result = space_state.intersect_ray(starting_position, destination_position, [self, $CollisionShape2D], 1)
	return result

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

func chop_tree(delta):
	populate_target_destination()
	var target = check_destination()
	if target.empty():
		return
	var collider = target.collider
	print(collider.get_parent().name)
	if "Tree" in collider.name:
		collider.chop_chop(delta)
