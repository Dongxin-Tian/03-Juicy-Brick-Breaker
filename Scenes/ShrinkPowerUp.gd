extends Area2D

var speed = -10

func _process(delta):
	speed += 0.1
	position.y += 7.5 * speed * delta
	
	if position.y >= 650:
		queue_free()
		
func _on_ExtendPowerUp_body_entered(body):
	if body.get_name() == "Paddle":
		body.shrink()
		queue_free()
