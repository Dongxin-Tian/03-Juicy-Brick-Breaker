extends Node2D

func _process(delta):
	$Lives.text = "Lives: " + str(Global.lives)
	$Score.text = "Score: " + str(Global.score)
	$Level.text = "Level: " + str(Global.level)
