extends StaticBody2D

var tree_log = preload("res://WorldParts/Log.tscn")
var plant_seed = preload("res://WorldParts/Seed.tscn")
var resource_amount = 5.0
var total_resource = resource_amount
var chop_progress = 0
var chop_total = 1
var rng =  RandomNumberGenerator.new()
var is_growing = false
var target_scale = 1.0
var scale_increase = Vector2(0.005, 0.005)

# Called when the node enters the scene tree for the first time.
func _ready():
	$TotalResources.value = 100
	rng.randomize()
	if is_growing:
		target_scale = 0.25
		resource_amount = 2.0
		scale = Vector2(0.25, 0.25)
		$GrowTimer.start()
		
func _process(delta):
	grow()
	update_grow_meter()

func grow():
	if scale.x < target_scale:
		print(str(scale.x), target_scale)
		scale += scale_increase

func update_grow_meter():
	$GrowMeter.value = scale.x * 100
	if $GrowMeter.value >= 100:
		$GrowMeter.visible = false
	else:
		$GrowMeter.visible = true


func remove_resource():
	resource_amount -= 1
	$TotalResources.value = (resource_amount / total_resource) * 100
	#print("total", resource_amount, total_resource, $TotalResources.value)
	dispense_resource()
	if resource_amount <= 0:
		var plant = plant_seed.instance()
		plant.position = position
		plant.position.y += 20
		get_tree().root.add_child(plant)
		self.queue_free()
	
func dispense_resource():
	var wood = tree_log.instance()
	wood.position = position
	wood.position.x += rng.randi_range(-10, 10)
	wood.position.y += rng.randi_range(-10, 10)
	
	get_tree().root.add_child(wood)

func chop_chop(delta):
	$MeterTimeout.stop()
	$MeterTimeout.start()
	update_meter_visibility(true)
	chop_progress += delta
	$CurrentChop.value = (chop_progress / chop_total) * 100
	#print(chop_progress, chop_total)
	$CurrentChop.update()
	if chop_progress >= chop_total:
		chop_progress -= 1
		remove_resource()
	
func update_meter_visibility(is_visible):
	$TotalResources.visible = is_visible
	$CurrentChop.visible = is_visible


func _on_MeterTimeout_timeout():
	update_meter_visibility(false)


func _on_GrowTimer_timeout():
	resource_amount += 1
	target_scale += 0.25
	if scale.x >= 1:
		$GrowTimer.stop()
		is_growing = false
