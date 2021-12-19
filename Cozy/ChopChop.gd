extends AudioStreamPlayer2D


var cooling_down = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_chop():
	print("Play")
	if cooling_down:
		print("Return")
		return
	cooling_down = true
	play()
	$PlayTimeout.start()


func _on_PlayTimeout_timeout():
	cooling_down = false
	$PlayTimeout.stop()
	


func _on_ChopChop_finished():
	stop()
