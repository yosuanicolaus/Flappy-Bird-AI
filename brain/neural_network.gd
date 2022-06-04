extends Object
class_name NeuralNetwork

var levels = []


func _init(neuron_counts: Array):
	for i in len(neuron_counts) - 1:
		var l = Level.new(neuron_counts[i], neuron_counts[i + 1])
		levels.append(l)


static func feed_forward(given_inputs, network: NeuralNetwork):
	var outputs

	for i in len(network.levels):
		if i == 0:
			outputs = Level.feed_forward(given_inputs, network.levels[0])
		else:
			outputs = Level.feed_forward(outputs, network.levels[i])

	return outputs
