extends KinematicBody2D

export var gravity = 20
export var jump_force = 360
export var max_speed = 200

var velocity = Vector2()
var alive = true
var die_count = 0
var score = 0

signal score_up(score)
signal dead(bird)
var emitted_dead = false

onready var brain = NeuralNetwork.new([2, 4, 1])


func _physics_process(_delta):
	if alive:
		feed_brain()
		active()
	else:
		die()


func feed_brain():
	var inputs = []
	var walls = get_tree().get_nodes_in_group("walls")
	var target
	for wall in walls:
		if wall.position.x < position.x:
			continue
		else:
			target = wall
			break
	if target:
		inputs.append(target.position.x - position.x)
		inputs.append(target.position.y - position.y)
		var outputs = NeuralNetwork.feed_forward(inputs, brain)
		if outputs[0] == 1:
			jump()


func active():
	velocity.y += gravity
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	velocity = move_and_slide(velocity, Vector2.UP)


func jump():
	velocity.y = -jump_force


func die():
	if not emitted_dead:
		emit_signal("dead", self)
		emitted_dead = true
	position.x -= 1
	die_count += 1
	if die_count >= 100:
		queue_free()


func _on_Detect_body_entered(_body: Node):
	# dead
	modulate = Color(.5, .5, .5, .5)
	alive = false


func _on_ScoreDetector_area_entered(_area: Area2D):
	score += 1
	emit_signal("score_up", score)
