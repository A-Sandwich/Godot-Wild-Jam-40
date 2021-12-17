extends StaticBody2D


var resource_amount = 5.0
var total_resource = resource_amount
var chop_progress = 0
var chop_total = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$TotalResources.value = 100


func remove_resource():
	resource_amount -= 1
	$TotalResources.value = (resource_amount / total_resource) * 100
	print("total", resource_amount, total_resource, $TotalResources.value)
	dispense_resource()
	if resource_amount <= 0:
		self.queue_free()
	
func dispense_resource():
	pass
	
func chop_chop(delta):
	$MeterTimeout.stop()
	$MeterTimeout.start()
	update_meter_visibility(true)
	chop_progress += delta
	$CurrentChop.value = (chop_progress / chop_total) * 100
	print(chop_progress, chop_total)
	$CurrentChop.update()
	if chop_progress >= chop_total:
		chop_progress -= 1
		remove_resource()
	
func update_meter_visibility(is_visible):
	$TotalResources.visible = is_visible
	$CurrentChop.visible = is_visible


func _on_MeterTimeout_timeout():
	update_meter_visibility(false)
