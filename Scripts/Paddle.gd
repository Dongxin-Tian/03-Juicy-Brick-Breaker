extends KinematicBody2D

export var speed = 30

var state = 0 # 0-Normal 1-Extend 2-Shrink
var time = 0.0
var resume = false

onready var target_y = position.y

func _process(delta):
	if time > 0:
		time -= 1 * delta
	else:
		time = 0
		if not resume:
			resume()
			resume = true

func _physics_process(_delta):
	var target = get_viewport().get_mouse_position().x
	target = clamp(target, 0, get_viewport().size.x)

	var d = abs(target - position.x)						# distance between the mouse and the paddle
	var p = d / get_viewport().get_visible_rect().size.x	# percentage of the total viewport
	var t = clamp(d, d, speed)							# how much to move the paddle this cycle (maximum of speed)
	var s = sign(target - position.x)					# which direction to move
	
	position.x += s*t

func resume():
	$Tween.interpolate_property(self, "scale", scale, Vector2(0.2, 0.2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	state = 0

func extend():
	if state != 1:
		$Tween.interpolate_property(self, "scale", scale, Vector2(0.35, 0.2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		state = 1
		resume = false
		time = 15.0
		
func shrink():
	if state != 2:
		$Tween.interpolate_property(self, "scale", scale, Vector2(0.15, 0.2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		state = 2
		resume = false
		time = 15.0
		
func emit_particle(pos):
	get_parent().find_node("Particles2D").global_position = pos
	get_parent().find_node("Particles2D").emitting = true
	get_parent().find_node("Particles2D").look_at(pos)
