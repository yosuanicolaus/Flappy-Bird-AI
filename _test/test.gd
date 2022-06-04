extends Node2D

var Bird = preload("res://bird/Bird.tscn")

var neuron_counts = [4, 2, 1]


func _ready():
	var a = Bird.instance()
	var b = Bird.instance()
	b.brain = a.brain.copy()
	b.position.x -= 50

	print_levels(a.brain)
	print_levels(b.brain)

	a.brain.mutate(0.6)
	print("\n\n\n")

	print_levels(a.brain)
	print_levels(b.brain)

	add_child(a)
	add_child(b)


func print_levels(nn):
	for level in nn.levels:
		print("weight")
		print(level.weights)
		print("biases")
		print(level.biases)
