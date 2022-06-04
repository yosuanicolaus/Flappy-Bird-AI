extends Object
class_name Population

var _Scene: PackedScene

var scenes = []
var mutation_rate = 0.01
var generation = 0


func _init(object, population_size):
	_Scene = object
	scenes.resize(population_size)
	for i in len(scenes):
		var scene = _Scene.instance()
		scenes[i] = scene


func reincarnate():
	for scene in scenes:
		scene.reincarnate(scene.brain)
