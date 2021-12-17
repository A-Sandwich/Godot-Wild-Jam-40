extends CanvasLayer

var logs = 0
var seeds = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	show_log_count()
	show_seed_count()
	
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

