extends KinematicBody2D

var cracked = preload("res://Sprites/WhiteCracked.png")

var extend = preload("res://Scenes/ExtendPowerUp.tscn")
var shrink = preload("res://Scenes/ShrinkPowerUp.tscn")

export var waitTime = 1.0
export var fall_speed = 1.0

var dying = false
export var crack = true
var colors = [
	Color8(224,49,49)		#Red 8
	,Color8(253,126,20)		#Orange 6
	,Color8(255,224,102)		#Yellow 3
	,Color8(148,216,45)		#Lime 5
	,Color8(34,139,230)		#Blue 6
	,Color8(190,75,219)		#Violet 5
	,Color8(132,94,247)		#Grape 6
]
export var colorIndex = 0

onready var textures = [
	load("res://Assets/smoke0.png")
	,load("res://Assets/smoke1.png")
	,load("res://Assets/smoke2.png")
	,load("res://Assets/smoke3.png")
]

func _ready():
	randomize()
	var prePos = position - Vector2(0, 1500)
	position = prePos
	$Sprite.modulate = colors[colorIndex]
	var t = Timer.new()
	t.set_wait_time(1 + waitTime)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	$Tween.interpolate_property(self, "position", prePos, prePos + Vector2(0, 1500), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	t.queue_free()
	
	tweenColor()

func tweenColor():
	if not dying:
		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		
		$ColorTween.interpolate_property($Sprite, "modulate", $Sprite.modulate, colors[colorIndex], 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$ColorTween.start()
		colorIndex -= 1
		if colorIndex < 0:
			colorIndex = 6
		t.queue_free()
		
		tweenColor()

func die():
	if crack:
		dying = true
		var fall_duration = randf()*fall_speed + 1
		
		get_node("/root/Game/Controller").BreakBrick()
		
		var chance = randi()%10+1
		if chance == 1:
			var ex = extend.instance()
			get_tree().current_scene.add_child_below_node(get_node("/root/Game/ItemContainer"), ex)
			ex.global_position = global_position
		elif chance == 2:
			var sh = shrink.instance()
			get_tree().current_scene.add_child_below_node(get_node("/root/Game/ItemContainer"), sh)
			sh.global_position = global_position
	
		var target_pos = position
		target_pos.y = 1000
		$Tween.interpolate_property(self, "position", position, target_pos, fall_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
	
		collision_layer = 0
		collision_mask = 0
		
		var endColor = $Sprite.modulate
		endColor.a = 0.0
		$ColorTween.interpolate_property(self, "modulate", $Sprite.modulate, endColor, 1, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$ColorTween.start()
		dying = false
			
		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
			
		queue_free()
			
		t.queue_free()
	else:
		crack = true
		$Sprite.set_texture(cracked)
		
func emit_particle(pos):
	$Particles2D.texture = textures[randi() % textures.size()]
	$Particles2D.emitting = true
	$Particles2D.global_position = pos
