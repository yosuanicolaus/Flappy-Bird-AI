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
var gen = 0
var average = 0
var alive = 100
var running = true

@onready var screen = get_viewport_rect().size
@onready var wall_timer = $WallTimer
@onready var score_label = $UI/ScoreNumber
@onready var best_label = $UI/BestNumber
@onready var gen_label = $UI/GenNumber
@onready var average_label = $UI/AverageNumber
@onready var alive_label = $UI/AliveNumber


func _ready():
	for bird in population.scenes:
		bird.connect("score_up",Callable(self,"_on_Bird_score_up"))
		bird.connect("dead",Callable(self,"_on_Bird_dead"))
		add_child(bird)
	
	alive_label.text = str(alive)
	create_wall()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			print("test")
			running = not running
			if running:
				Engine.time_scale = 1
			else:
				Engine.time_scale = 0
		if event.keycode == KEY_1:
			Engine.time_scale = 1
		if event.keycode == KEY_2:
			Engine.time_scale = 2
		if event.keycode == KEY_3:
			Engine.time_scale = 3
		if event.keycode == KEY_4:
			Engine.time_scale = 4


func create_wall():
	var mid_screen_y = screen.y / 2
	var wall_y = mid_screen_y + randf_range(-1, 1) * wall_offset
	var wall_pos = Vector2(screen.x + 30, wall_y)
	var w = Wall.instantiate()
	w.set_gap(gap)
	w.position = wall_pos
	add_child(w)


func increase_difficulty():
	if gap > min_gap:
		gap -= 1
	if wall_offset < max_offset:
		wall_offset += 1


func calculate_average():
	var sum = 0
	for bird in population.scenes:
		sum += bird.score
	average = float(sum) / pop_size
	average_label.text = str(average)


func _on_WallTimer_timeout():
	if running:
		create_wall()
		increase_difficulty()


func _on_Bird_score_up(score, _bird):
	calculate_average()
	score_label.text = str(score)
	if score > best_score:
		best_score = score
		best_label.text = str(best_score)


func _on_Bird_dead(_bird):
	# reset simulation when all birds are dead
	alive -= 1
	alive_label.text = str(alive)
	if alive == 0:
		reset()


func reset():
	running = false
	wall_timer.stop()
	gap = 150
	wall_offset = 100

	# 2 seconds delay before going to next generation
	await get_tree().create_timer(2).timeout

	var walls = get_tree().get_nodes_in_group("walls")
	for w in walls:
		w.queue_free()

	population.reincarnate()
	gen += 1
	average = 0
	alive = 100
	running = true
	gen_label.text = str(gen)
	score_label.text = str(0)
	create_wall()
	wall_timer.start()
