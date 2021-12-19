extends KinematicBody2D

var is_moving = false
var starting_position = Vector2(8, 8)
var destination_position = Vector2(24, 8)
var offset = Vector2(8, 8)
var grid_size = 16
var base_movement_speed = 100
var movement_speed = base_movement_speed
var movement_direction = Vector2.ZERO
var target_direction = Vector2.ZERO
var tree = preload("res://WorldParts/Tree.tscn")
var heat = 100
var cooling_rate = 2.5
var is_cooling = true


func _ready():
	pass

func _physics_process(delta):
	process_input(delta)
	regulate_body_heat(delta)
	heat_up(delta)
	play_animation()
	move(delta)

func regulate_body_heat(delta):
	if is_cooling:
		heat -= delta * cooling_rate
	else:
		heat += delta * (cooling_rate * 4)
	heat = clamp(heat, 0, 100)
	if heat <= 0:
		movement_speed = base_movement_speed / 2
	else:
		movement_speed = base_movement_speed
	$HUD.heat_change(heat)
		

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
		feed_fire()
		plant_seed()
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
		choose_animation()
		var original_position = populate_target_destination()
		update()
		if is_position_invalid():
			destination_position = original_position
			is_moving = false
			movement_direction = Vector2.ZERO
			#print("Position invalid")
			return
		else:
			is_moving = true

func _draw():
	#print("drawing", starting_position, destination_position)
	draw_line(to_local(starting_position), to_local(destination_position), Color(1, 1, 0))

func is_position_invalid():
	var result = check_destination()
	return !result.empty()

func populate_target_destination():
	var original_position = global_position
	var move_vector = movement_direction if movement_direction != Vector2.ZERO else target_direction
	starting_position = global_position + offset
	destination_position = starting_position + (move_vector * grid_size)
	#print("start", starting_position, "dest", destination_position, move_vector * grid_size)
	return original_position
	
func check_destination():
	update()
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var ignore = get_tree().get_nodes_in_group("log")
	ignore.append_array(get_tree().get_nodes_in_group("seed"))
	ignore.append(self)
	ignore.append($CollisionShape2D)
	var result = space_state.intersect_ray(starting_position, destination_position, ignore, 1)
	return result

func choose_animation():
	if movement_direction.x == 1:
		target_direction = Vector2(1, 0)
		$AnimatedSprite.flip_h = false
	elif movement_direction.x == -1:
		target_direction = Vector2(-1, 0)
		$AnimatedSprite.flip_h = true

func play_animation():
	if $AnimatedSprite.playing and not is_moving and $AnimatedSprite.animation == "walk":
		$AnimatedSprite.stop()
	if is_moving:
		$AnimatedSprite.play("walk")

func chop_tree(delta):
	populate_target_destination()
	var target = check_destination()
	if target.empty():
		return
	var collider = target.collider
	#print(collider.get_parent().name)
	if "Tree" in collider.name:
		collider.chop_chop(delta)

func feed_fire():
	if $HUD.logs <= 0:
		return
	populate_target_destination()
	var target = check_destination()
	if target.empty():
		return
	var collider = target.collider
	if "Fire" in collider.name:
		$HUD.remove_log()
		if not collider.add_wood():
			$HUD.add_log()

func plant_seed():
	if $HUD.seeds <= 0:
		return
	var target = check_destination()
	if not target.empty():
		return
	$HUD.remove_seed()
	var plant = tree.instance()
	plant.position = destination_position
	plant.is_growing = true
	get_tree().root.add_child(plant)

func get_log():
	$HUD.add_log()

func add_seed():
	$HUD.add_seed()

func heat_up(delta):
	pass

func warm():
	print("Warming")
	is_cooling = false

func cool():
	print("Cooling")
	is_cooling = true
