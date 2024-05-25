extends TileMap

var _layers_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_layers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func get_layer_id_by_name(name):
	return _layers_dict[name]


func _set_layers():
	for layer_id in range(self.get_layers_count()):
		var layer_name = self.get_layer_name(layer_id)
		_layers_dict[layer_name] = layer_id
