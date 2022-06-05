extends Resource
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

	for i in len(biases):
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


func copy():
	var new_level = get_script().new(len(inputs), len(outputs))

	for i in len(inputs):
		for j in len(outputs):
			new_level.weights[i][j] = weights[i][j]

	for i in len(biases):
		new_level.biases[i] = biases[i]

	return new_level


func mutate(rate):
	for i in len(inputs):
		for j in len(outputs):
			if randf() < rate:
				# weights[i][j] = rand_range(-1, 1)
				# weights[i][j] *= rand_range(1-rate, 1+rate)
				weights[i][j] = lerp(weights[i][j], rand_range(-1, 1), rate)

	for i in len(biases):
		if randf() < rate:
			# biases[i] = rand_range(-1, 1)
			# biases[i] *= rand_range(1-rate, 1+rate)
			biases[i] = lerp(biases[i], rand_range(-1, 1), rate)
