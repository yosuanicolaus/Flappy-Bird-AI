extends Node2D

@export var gravity = 20
@export var jump_force = 363
@export var max_speed = 400
var fps = Engine.physics_ticks_per_second

var velocity = Vector2()
var alive = true
var die_count = 0
var score = 0

signal score_up(score, bird)
signal dead(bird)

var brain = NeuralNetwork.new([2, 4, 1])


func _ready():
	$AnimatedSprite2D.frame = randi() % 9
	position = get_tree().get_root().get_size() / 2


func _physics_process(delta):
	if alive:
		feed_brain(delta)
		active(delta)
	else:
		dying()


func feed_brain(delta):
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
			jump(delta)


func active(delta):
	velocity.y += gravity * delta * fps
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	position += velocity * delta


func jump(delta):
	velocity.y = -jump_force * delta * fps


func dying():
	position.x -= 1
	die_count += 1
	if die_count >= 100:
		hide()
		set_process(false)


func reincarnate():
	position = get_tree().get_root().get_size() / 2
	score = 0
	die_count = 0
	alive = true
	velocity = Vector2()
	modulate = Color(1, 1, 1, 1)
	$Detect.set_deferred("monitoring", true)
	show()
	set_process(true)


func _on_Detect_body_entered(_body: Node):
	# dead
	modulate = Color(.5, .5, .5, .5)
	alive = false
	$Detect.set_deferred("monitoring", false)
	emit_signal("dead", self)


func _on_Detect_area_entered(_area: Area2D):
	score += 1
	emit_signal("score_up", score, self)
