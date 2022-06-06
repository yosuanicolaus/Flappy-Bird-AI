extends Object
class_name Population

var _Scene: PackedScene

var scenes = []
var mutation_rate = 0.1
var generation = 0


func _init(object, population_size):
	_Scene = object
	scenes.resize(population_size)
	for i in len(scenes):
		var scene = _Scene.instance()
		scenes[i] = scene


func selection():
	var pool = []
	var best_score = 0
	var best_scene
	for scene in scenes:
		for s in scene.score:
			pool.append(scene)
		if scene.score > best_score:
			best_score = scene.score
			best_scene = scene

	for i in len(scenes):
		if i == 0:
			# save best scene's brain as first scene
			scenes[i].brain = best_scene.brain
			continue
		var r = randi() % len(pool)
		var scene = pool[r]
		var new_brain = scene.brain.copy()
		new_brain.mutate(mutation_rate)
		scenes[i].brain = new_brain


func reincarnate():
	selection()

	for scene in scenes:
		scene.reincarnate()
