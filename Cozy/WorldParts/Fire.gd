extends StaticBody2D


var max_logs = 6
var current_logs = 1
var particle_step = 15
var log_burn_time = 10.0
var burn_time = 0.0
var extra_particles = []
var radius_increase = 25
var base_radius = 250
var target_radius = base_radius
var current_radius = target_radius

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _draw():
	draw_circle(Vector2(0,0), current_radius, Color(1, 0, 0, 0.15))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	burn(delta)
	update_burn_meter()
	#print(str(burn_time))

func burn(delta):
	burn_time += delta
	if burn_time >= log_burn_time:
		burn_time = 0
		if len(extra_particles) > 0:
			var particle = extra_particles[0]
			extra_particles.remove(0)
			particle.queue_free()
		else:
			$FireParticle.visible = false
		if current_logs > 1:
			remove_log()

func update_burn_meter():
	if $FireParticle.visible:
		$BurnMeter.visible = true
		$BurnMeter.value = clamp(((log_burn_time - burn_time) / log_burn_time) * 100, 0, 100)
	else:
		$BurnMeter.visible = false

func remove_log():
	current_logs -= 1
	get_node("Wood/log"+str(current_logs)).visible = false
	$Warmth/CollisionShape2D.shape.radius -= radius_increase
	current_radius -= radius_increase
	update()
	
func add_wood():
	if current_logs >= max_logs:
		return false
	get_node("Wood/log"+str(current_logs)).visible = true
	current_logs += 1
	$Warmth/CollisionShape2D.shape.radius += radius_increase
	current_radius += radius_increase
	update()
	if not $FireParticle.visible:
		$FireParticle.visible = true
	else:
		var particle = $FireParticle.duplicate()
		particle.position = $FireParticle.position
		extra_particles.append(particle)
		add_child(particle)
	return true

func _on_Warmth_body_entered(body):
	if "Player" in body.name:
		body.warm()

func _on_Warmth_body_exited(body):
	if "Player" in body.name:
		body.cool()
