extends KinematicBody2D

export var speed = 30

var extended = false
var shrinked = false

onready var target_y = position.y

func _physics_process(_delta):
	var target = get_viewport().get_mouse_position().x
	target = clamp(target, 0, get_viewport().size.x)

	var d = abs(target - position.x)						# distance between the mouse and the paddle
	var p = d / get_viewport().get_visible_rect().size.x	# percentage of the total viewport
	var t = clamp(d, d, speed)							# how much to move the paddle this cycle (maximum of speed)
	var s = sign(target - position.x)					# which direction to move
	
	position.x += s*t

func extend():
	if extended == false:
		$Tween.interpolate_property(self, "scale", scale, Vector2(0.35, 0.2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		extended = true
		
		var t = Timer.new()
		t.set_wait_time(10)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		
		if shrinked == false:
			$Tween.interpolate_property(self, "scale", scale, Vector2(0.2, 0.2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Tween.start()
			extended = false
		
		t.queue_free()
		
func shrink():
	if shrinked == false:
		$Tween.interpolate_property(self, "scale", scale, Vector2(0.15, 0.2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		shrinked = true
		
		var t = Timer.new()
		t.set_wait_time(10)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		
		if extended == false:
			$Tween.interpolate_property(self, "scale", scale, Vector2(0.2, 0.2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Tween.start()
			shrinked = false
		
		t.queue_free()
