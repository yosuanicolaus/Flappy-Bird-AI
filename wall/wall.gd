extends Node2D

var move_speed = 120


func set_gap(gap):
	$Up.position.y -= gap / 2
	$Down.position.y += gap / 2
	$ScoreArea.scale.y = gap / 2


func _process(delta):
	position.x -= move_speed * delta

	if position.x <= -30:
		queue_free()
