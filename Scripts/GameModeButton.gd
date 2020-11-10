extends Button

export var sceneName = ""

func _on_ClassicMode_pressed():
	get_tree().change_scene("res://Scenes/" + sceneName)
	Global.Resume()
