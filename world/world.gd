extends Node2D

var Bird = preload("res://bird/Bird.tscn")
var Wall = preload("res://wall/Wall.tscn")

var pop_size = 100
var gap = 150
var min_gap = 50
var wall_offset = 100
var max_offset = 300

var population = Population.new(Bird, pop_size)

var best_score = 0
var running = true
var turbo = false

onready var screen = get_viewport_rect().size
onready var score_label = $UI/ScoreNumber
onready var best_label = $UI/BestNumber


func _ready():
	for bird in population.scenes:
		bird.connect("score_up", self, "_on_Bird_score_up")
		bird.connect("dead", self, "_on_Bird_dead")
		add_child(bird)

	create_wall()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		turbo = not turbo
		if turbo:
			Engine.time_scale = 4
		else:
			Engine.time_scale = 1



func create_wall():
	var mid_screen_y = screen.y / 2
	var wall_y = mid_screen_y + rand_range(-1, 1) * wall_offset
	var wall_pos = Vector2(screen.x + 30, wall_y)
	var w = Wall.instance()
	w.set_gap(gap)
	w.position = wall_pos
	add_child(w)


func increase_difficulty():
	if gap > min_gap:
		gap -= 1
	if wall_offset < max_offset:
		wall_offset += 1


func _on_WallTimer_timeout():
	if running:
		create_wall()
		increase_difficulty()


func _on_Bird_score_up(score, _bird):
	score_label.text = str(score)
	if score > best_score:
		best_score = score
		best_label.text = str(best_score)


func _on_Bird_dead(_bird):
	# everytime a bird dies, check if all birds are dead
	var all_dead = true
	for bird in population.scenes:
		if bird.alive:
			all_dead = false
			break
	if all_dead:
		reset()


func reset():
	running = false
	$WallTimer.stop()
	gap = 150
	wall_offset = 100

	# 2 seconds delay before going to next generation
	yield(get_tree().create_timer(2), "timeout")

	var walls = get_tree().get_nodes_in_group("walls")
	for w in walls:
		w.queue_free()

	population.reincarnate()
	running = true
	create_wall()
	$WallTimer.start()
