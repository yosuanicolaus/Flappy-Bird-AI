extends Object
class_name Level

var inputs = []
var outputs = []
var weights = []
var biases = []


func _init(input_count, output_count):
	inputs.resize(input_count)
	outputs.resize(output_count)
	biases.resize(output_count)
	weights.resize(input_count)
	for i in input_count:
		weights[i] = []
		weights[i].resize(output_count)
	_randomize()


func _randomize():
	for i in len(inputs):
		for j in len(outputs):
			weights[i][j] = rand_range(-1, 1)

	for i in len(inputs):
		biases[i] = rand_range(-1, 1)


static func feed_forward(given_inputs, level: Level):
	for i in len(given_inputs):
		level.inputs[i] = given_inputs[i]

	for i in len(level.outputs):
		var sum = 0
		for j in len(level.inputs):
			sum += level.weights[j][i] * level.inputs[j]

		if sum > level.biases[i]:
			level.outputs[i] = 1
		else:
			level.outputs[i] = 0

	return level.outputs
