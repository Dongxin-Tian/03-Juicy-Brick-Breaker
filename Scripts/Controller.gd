extends Node2D

export var brickNumber = 50
var goBackButton := preload("res://Scenes/GoBackButton.tscn")
var ball := preload("res://Scenes/Ball.tscn")

func _process(delta):
	if Global.lives <= 0:
		var back := goBackButton.instance()
		back.position = Vector2(0, 0)
		get_tree().current_scene.add_child_below_node(get_node("../UI"), back)
		
	if Input.is_key_pressed(KEY_K):
		Global.level += 1
		if Global.level > 3:
			get_tree().change_scene("res://Scenes/Win.tscn")
		else:
			get_tree().change_scene("res://Scenes/Level" + str(Global.level) + ".tscn")

func BreakBrick():
	brickNumber -= 1
	Global.score += 100
	if brickNumber <= 0:
		Global.level += 1
		if Global.level > 3:
			get_tree().change_scene("res://Scenes/Win.tscn")
		else:
			get_tree().change_scene("res://Scenes/Level" + str(Global.level) + ".tscn")

func CreateBall():
	if Global.lives > 1:
		var b := ball.instance()
		b.position = Vector2(-22, 130)
		get_tree().current_scene.add_child_below_node(get_node("../BallContainer"), b)
