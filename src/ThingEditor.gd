@icon("res://addons/thing-editor/ico.png")
class_name ThingEditor
extends Control 

# Boilerplate manager to map UI Editable Fields to an Object's ("Thing's") properties.

signal property_changed(property_name : StringName, value : Variant)

@export_group("Setup")

@export var thing : Resource = null
@export var property_sources : Array[PropertySource] = []

@export_group("Options")

@export var disable_not_found_properties : bool = false
@export var reject_unlike_resources : bool = true
@export var print_all_changes : bool = false

func _ready():
	if thing == null: 
		push_error("%s has no reference thing." % [self])
		return

	var property_list = _get_thing_property_list()
	for property_source in property_sources:
		if property_source.property_name in property_list:
			_setup_property_source(property_source)
		else:
			print("Disable!")

	ParasiteEventManager.subscribe("all/loaded_new_sequence", 
		func(data): load_thing(data["sequence"])
	)

func load_thing(_thing : Variant):
	self.thing = _thing
	for property_source in property_sources:
		var node = get_node(property_source.node_path)
		var new_value = thing.get(property_source.property_name)
		if new_value == null:
			print("Disable '%s'!" % [property_source.property_name])
			continue
		node.set(property_source.node_source_property_name, new_value)

func _setup_property_source(property_source : PropertySource):
	if not thing.has_method("validate_property_value"):
		push_error("%s does not provide required 'validate_property_value()' function." % [thing])
		return

	var node = get_node(property_source.node_path)

	if not node.has_signal(property_source.node_submission_signal):
		push_error("%s does not have signal '%s'." % [node, property_source.node_submission_signal])
		return

	node.connect(property_source.node_submission_signal, 
		# Workaround to emulate variadic function.
		# Callable must be compatible with any signal args signature.
		func(
			_a0 = null, # I LOVE GODOT ENGINE
			_a1 = null, # I LOVE GODOT ENGINE
			_a2 = null, # I LOVE GODOT ENGINE
			_a3 = null, # I LOVE GODOT ENGINE
			_a4 = null, # I LOVE GODOT ENGINE
			_a5 = null, # I LOVE GODOT ENGINE
			_a6 = null, # I LOVE GODOT ENGINE
			_a7 = null  # I LOVE GODOT ENGINE
		):
			var property_name = property_source.property_name
			var new_value = node.get(property_source.node_source_property_name)
			if thing.validate_property_value(property_name, new_value):
				thing.set(property_name, new_value)
				property_changed.emit(property_name, new_value)
				if print_all_changes: 
					print("New value for %s: '%s'" % [property_name, new_value])
	)

func _get_thing_property_list() -> Array[StringName]:
	var property_list = thing.get_property_list()
	#print(property_list)
	for item in property_list:
		var item_name = item.get("name")
		#print("%s : %s" % [item_name, len(item)])
		if item.get("name").substr(len(item_name) - 3) == ".gd":
			var start_idx = property_list.find(item) + 1
			#print(start_idx)
			var output : Array[StringName] = []
			for idx in range(start_idx, len(property_list)):
				output.append(property_list[idx].get("name"))
			return output
	return []
