extends Node2D


func _process(delta):
	print(delta * Engine.get_frames_per_second())


func print_levels(nn):
	for level in nn.levels:
		print("weight")
		print(level.weights)
		print("biases")
		print(level.biases)
