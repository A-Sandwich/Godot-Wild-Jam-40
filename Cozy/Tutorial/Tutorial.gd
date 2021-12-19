extends CanvasLayer


var second_text = "\nStay warm by \n standing near the fire.\nPlant a tree by pressing\n'e' next to an empty space\nif you have a seed."

func _on_Button_pressed():
	if $Label.text != second_text:
		$Label.text = second_text
		return
	get_tree().change_scene("res://World.tscn")
