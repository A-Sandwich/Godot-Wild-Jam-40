extends CanvasLayer

var logs = 0
var seeds = 0
var current_temp = 100.0
var target_temp = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Heat/Warmth.value = current_temp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	show_log_count()
	show_seed_count()
	update_warmth(delta)

func update_warmth(delta):
	if target_temp == current_temp:
		return
	var change_in_temp = 0.0
	if current_temp < target_temp:
		change_in_temp = (target_temp - current_temp) * delta
	elif current_temp > target_temp:
		change_in_temp = (target_temp - current_temp) * delta
	current_temp += change_in_temp
	$Heat/Warmth.value = current_temp
	
func show_seed_count():
	if seeds <= 0:
		$Seed.visible = false
	else:
		$Seed.visible = true

func show_log_count():
	if logs <= 0:
		$Log.visible = false
	else:
		$Log.visible = true

func remove_log():
	logs -= 1

func add_log():
	logs += 1
	$Log/LogNumber.text = str(logs)

func remove_seed():
	seeds -= 1

func add_seed():
	seeds += 1
	$Seed/Label.text = str(seeds)

func heat_change(heat):
	target_temp = heat
