extends KinematicBody2D

export var gravity = 20
export var jump_force = 363
export var max_speed = 400

var velocity = Vector2()
var alive = true
var die_count = 0
var score = 0

signal score_up(score, bird)
signal dead(bird)

var brain = NeuralNetwork.new([2, 4, 1])


func _ready():
	position = get_tree().get_root().get_size() / 2


func _physics_process(_delta):
	if alive:
		feed_brain()
		active()
	else:
		dying()


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


func dying():
	position.x -= 1
	die_count += 1
	if die_count >= 100:
		hide()
		set_process(false)


func reincarnate(new_brain: NeuralNetwork):
	brain = new_brain
	position = get_tree().get_root().get_size() / 2
	score = 0
	die_count = 0
	alive = true
	velocity = Vector2()
	$Detect.set_deferred("monitoring", true)
	show()
	set_process(true)


func _on_Detect_body_entered(_body: Node):
	# dead
	modulate = Color(.5, .5, .5, .5)
	alive = false
	$Detect.set_deferred("monitoring", false)
	emit_signal("dead", self)


func _on_ScoreDetector_area_entered(_area: Area2D):
	score += 1
	emit_signal("score_up", score, self)
