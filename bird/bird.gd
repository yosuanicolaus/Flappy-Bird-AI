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


func _physics_process(_delta):
	if alive:
		active()
	else:
		die()


func active():
	velocity.y += gravity

	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_force
	if velocity.y > max_speed:
		velocity.y = max_speed

	velocity = move_and_slide(velocity, Vector2.UP)


func die():
	if not emitted_dead:
		emit_signal("dead", self)
		emitted_dead = true
	position.x -= 1
	die_count += 1
	if die_count >= 100:
		queue_free()


func _on_Detect_body_entered(_body: Node):
	modulate = Color(.5, .5, .5, .5)
	alive = false
	print("dead")


func _on_ScoreDetector_area_entered(_area: Area2D):
	score += 1
	emit_signal("score_up", score)
