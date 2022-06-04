extends Resource
class_name NeuralNetwork

var levels = []
var formation


func _init(neuron_counts: Array):
	formation = neuron_counts
	for i in len(formation) - 1:
		var l = Level.new(formation[i], formation[i + 1])
		levels.append(l)


static func feed_forward(given_inputs, network: NeuralNetwork):
	var outputs

	for i in len(network.levels):
		if i == 0:
			outputs = Level.feed_forward(given_inputs, network.levels[0])
		else:
			outputs = Level.feed_forward(outputs, network.levels[i])

	return outputs


func copy():
	var new_network = get_script().new(formation)

	for i in len(levels):
		new_network.levels[i] = levels[i].copy()

	return new_network


func mutate(rate):
	for i in len(levels):
		levels[i].mutate(rate)
