extends Node2D

var x = 0 setget update_x


func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		print("updating x")
		self.x = randi()
		print(x)


func update_x(value):
	print("updating label...", value)
	$Label.text = str(value)


func print_levels(nn):
	for level in nn.levels:
		print("weight")
		print(level.weights)
		print("biases")
		print(level.biases)
