extends RigidBody2D

export var max_speed = 400.0
export var min_speed = 100.0
export var screen_shake = 0.5
onready var camera = get_node("/root/Game/Camera")

onready var effect_paddle = get_node("/root/Game/Audio/se_paddle")
onready var effect_wall = get_node("/root/Game/Audio/se_wall")
onready var effect_brick = get_node("/root/Game/Audio/se_brick")

var wall_trauma = 0.005
var paddle_trauma = 0.008
var brick_trauma = 0.01

var started = false

func _ready():
	contact_monitor = true
	set_max_contacts_reported(4)

func screen_shake(amount):
	camera.add_trauma(screen_shake)

func play_sound(sound):
	sound.play()

func _physics_process(_delta):
	if Input.is_action_pressed("Start") and not started:
		apply_central_impulse(Vector2(750,-750))
		started = true
	
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.name == "Walls":
			screen_shake(wall_trauma)
			play_sound(effect_wall)
		if body.name == "Paddle":
			screen_shake(paddle_trauma)
			play_sound(effect_paddle)
		if body.is_in_group("Brick"):
			screen_shake(brick_trauma)
			play_sound(effect_brick)
		if body.name == "LoseArea":
			get_node("/root/Game/Controller").CreateBall()
			started = false
			Global.lives -= 1
			queue_free()
		if body.has_method("emit_particle"):
			body.emit_particle(global_position)
		if body.is_in_group("Brick"):
			body.die()

func _integrate_forces(state):
	if abs(state.linear_velocity.x) < min_speed:
		state.linear_velocity.x = sign(state.linear_velocity.x) * min_speed
	if abs(state.linear_velocity.y) < min_speed:
		state.linear_velocity.y = sign(state.linear_velocity.y) * min_speed
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
