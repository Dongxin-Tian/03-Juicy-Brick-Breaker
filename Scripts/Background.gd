extends ColorRect

func _ready():
	$Tween.interpolate_property(self, "color", Color8(255, 255, 255), Color8(0, 0, 0), 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
