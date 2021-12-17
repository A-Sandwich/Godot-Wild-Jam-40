extends StaticBody2D

var tree_log = preload("res://WorldParts/Log.tscn")
var plant_seed = preload("res://WorldParts/Seed.tscn")
var resource_amount = 5.0
var total_resource = resource_amount
var chop_progress = 0
var chop_total = 1
var rng =  RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$TotalResources.value = 100
	rng.randomize()


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
