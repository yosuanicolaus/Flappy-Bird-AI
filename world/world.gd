extends Node2D

var bird = preload("res://bird/Bird.tscn")
var wall = preload("res://wall/Wall.tscn")

var population = []
var pop_size = 25
var mutation_rate = 0.01
var generation = 0

var gap = 150
var min_gap = 50
var wall_offset = 100
var max_offset = 300

var best_score = 0
var running = true

onready var screen = get_viewport_rect().size
onready var score_label = $UI/ScoreNumber
onready var best_label = $UI/BestNumber


func _ready():
	population.resize(pop_size)
	for i in pop_size:
		var b = bird.instance()
		b.connect("score_up", self, "_on_Bird_score_up")
		b.connect("dead", self, "_on_Bird_dead")
		population[i] = b
		add_child(b)
	create_wall()


func create_wall():
	var mid_screen_y = screen.y / 2
	var wall_y = mid_screen_y + rand_range(-1, 1) * wall_offset
	var wall_pos = Vector2(screen.x + 30, wall_y)
	var w = wall.instance()
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
	for b in population:
		if b.alive:
			all_dead = false
			break
	if all_dead:
		reset()


func reset():
	gap = 150
	wall_offset = 100

	# 2 seconds delay before going to next generation
	yield(get_tree().create_timer(2), "timeout")

	var walls = get_tree().get_nodes_in_group("walls")
	for w in walls:
		w.queue_free()

	for b in population:
		b.reincarnate(b.brain)
