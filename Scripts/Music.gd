extends Node2D

func _ready():
	$BGM.play()

func play(playOrNot):
	if playOrNot:
		$BGM.play()
	else:
		$BGM.stop()
