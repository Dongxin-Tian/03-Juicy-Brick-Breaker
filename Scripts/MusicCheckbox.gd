extends CheckButton

func _on_CheckButton_toggled(button_pressed):
	Music.play(button_pressed)
