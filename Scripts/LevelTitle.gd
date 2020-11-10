extends Node2D

func _ready():
	$Tween.interpolate_property(self, "position", Vector2(750, 0), Vector2(0, 0), 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	$Tween.interpolate_property(self, "position", Vector2(0, 0), Vector2(-750, 0), 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	t.queue_free()
