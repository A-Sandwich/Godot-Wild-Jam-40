extends Node2D


var total = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	total += delta
	if total > 1.5 and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Tutorial/Tutorial.tscn")
