extends CanvasLayer

var logs = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if logs <= 0:
		$Log.visible = false
	else:
		$Log.visible = true

func remove_log():
	logs -= 1

func add_log():
	$Log/LogNumber.text = str(logs)
	logs += 1
