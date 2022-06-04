extends Node2D

var gap = 150
var min_gap = 50
var wall_offset = 100
var max_offset = 300
var wall = preload("res://wall/Wall.tscn")

var running = true

onready var screen = get_viewport_rect().size
onready var score_label = $UI/ScoreNumber
onready var best_label = $UI/BestNumber


func _ready():
	create_wall()


func _input(_event):
	if not running and Input.is_action_just_pressed("ui_accept"):
		var _status = get_tree().reload_current_scene()


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
	create_wall()
	increase_difficulty()


func _on_Bird_score_up(score):
	score_label.text = str(score)


func _on_Bird_dead(_bird):
	running = false
