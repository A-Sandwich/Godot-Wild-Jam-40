extends AudioStreamPlayer2D

func _ready():
	pass # Replace with function body.


func _on_ResourceGet_finished():
	self.queue_free()
