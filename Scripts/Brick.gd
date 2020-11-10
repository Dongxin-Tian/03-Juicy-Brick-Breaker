extends KinematicBody2D

var extend = preload("res://Scenes/ExtendPowerUp.tscn")
var shrink = preload("res://Scenes/ShrinkPowerUp.tscn")

export(Texture) var brick
export(Texture) var cracked
export var waitTime = 1.0
export var fall_speed = 1.0

var dying = false
var crack = false

func _ready():
	randomize()
	$Sprite.texture = brick

onready var ctrl = get_node("/root/Game/Controller")

onready var textures = [
	load("res://Assets/smoke0.png")
	,load("res://Assets/smoke1.png")
	,load("res://Assets/smoke2.png")
	,load("res://Assets/smoke3.png")
]

func die():
	if crack:
		dying = true
		var fall_duration = randf()*fall_speed + 1
	
		ctrl.BreakBrick()
	
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
		$ColorTween.interpolate_property(self, "modulate", $Sprite.modulate, endColor, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
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
		$Sprite.texture = cracked
		
func emit_particle(pos):
	$Particles2D.texture = textures[randi() % textures.size()]
	$Particles2D.emitting = true
	$Particles2D.global_position = pos
