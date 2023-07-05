class_name ThingConverter

var verbose

static func thing_to_dict(obj : Object, verbose : bool = false) -> Dictionary:
	var conv = ThingConverter.new()
	conv.verbose = verbose
	return conv._deep_dict_object(obj)

func _deep_dict_object(object, tabs = "") -> Dictionary:
	if verbose: print(tabs + "Object Type: %s" % [object.get_class()])
	if object.get_class() == "GDScript": return {}
	var dict = {}
	
	var property_list = object.get_property_list()
	var start_idx
	for property in property_list:
		var property_name = property.get("name")
		#print("%s : %s" % [item_name, len(item)])
		if property_name.substr(len(property_name) - 3) == ".gd":
			start_idx = property_list.find(property) + 1
			break

	#print(start_idx)
	for idx in range(start_idx, len(property_list)):
		var property_name = property_list[idx].get("name")
		if verbose: print(tabs + "Processing '%s' property." % [property_name])
		var new_value = _deep_element(object.get(property_name), tabs + "\t")
		#print("Adding '%s':%s to dict" % [property_name, new_value])
		if new_value != null: dict[property_name] = new_value

	return dict

func _deep_dict_dict(dict : Dictionary, tabs : String) -> Dictionary:
	if verbose: print(tabs + "Deep converting dictionary: %s." % [dict])
	var new_dict = {}
	for key in dict.keys():
		var element = dict[key]
		if verbose: print(tabs + "KEY:")
		var new_key = _deep_element(key, tabs + "\t")

		if verbose: print(tabs + "VALUE:")
		var new_value = _deep_element(element, tabs + "\t")
		if new_value != null: new_dict[new_key] = new_value
	return new_dict

func _deep_dict_array(ar : Array, tabs : String) -> Array:
	var new_ar = []
	for idx in range(0, ar.size()):
		var element = ar[idx]
		var new_value = _deep_element(element, tabs + "\t")
		if new_value != null: new_ar.append(new_value)
	return new_ar

func _deep_element(element : Variant, tabs : String) -> Variant:
	var type_str = type_to_string[typeof(element)]
	match typeof(element):
		TYPE_NIL: 
			if verbose: print(tabs + "%s: Ignored. Continuing..." % [type_str])
			return null
		TYPE_STRING_NAME:
			if verbose: print(tabs + "%s: Converting to String..." % [type_str])
			return element as String
		TYPE_ARRAY:
			if verbose: print(tabs + "%s: Requires deepening..." % [type_str])
			var v = _deep_dict_array(element, tabs)
			if v.size() == 0:
				if verbose: print(tabs + "Failed. Continuing...")
				return null
			if verbose: print(tabs + "Deepened Array: %s" % [v])
			return v
		TYPE_DICTIONARY:
			if verbose: print(tabs + "%s: Requires deepening..." % [type_str])
			var v = _deep_dict_dict(element, tabs)
			if v.keys().size() == 0:
				if verbose: print(tabs + "Failed. Continuing...")
				return null
			if verbose: print(tabs + "Deepened Dict: %s" % [v])
			return v
		TYPE_OBJECT:
			if verbose: print(tabs + "%s: Requires deepening..." % [type_str])
			var v = _deep_dict_object(element, tabs)
			if v.keys().size() == 0:
				print(tabs + "Failed. Continuing...")
				return null
			if verbose: print(tabs + "Deepened Object: %s" % [v])
			return v
		_:
			if verbose: print(tabs + "%s" % [type_str])
			return element

const type_to_string = ["TYPE_NIL", "TYPE_BOOL", "TYPE_INT", "TYPE_FLOAT", "TYPE_STRING", "TYPE_VECTOR2", "TYPE_VECTOR2I", "TYPE_RECT2", "TYPE_RECT2I", "TYPE_VECTOR3", "TYPE_VECTOR3I", "TYPE_TRANSFORM2D", "TYPE_VECTOR4", "TYPE_VECTOR4I", "TYPE_PLANE", "TYPE_QUATERNION", "TYPE_AABB", "TYPE_BASIS", "TYPE_TRANSFORM3D", "TYPE_PROJECTION", "TYPE_COLOR", "TYPE_STRING_NAME", "TYPE_NODE_PATH", "TYPE_RID", "TYPE_OBJECT", "TYPE_CALLABLE", "TYPE_SIGNAL", "TYPE_DICTIONARY", "TYPE_ARRAY", "TYPE_PACKED_BYTE_ARRAY", "TYPE_PACKED_INT32_ARRAY", "TYPE_PACKED_INT64_ARRAY", "TYPE_PACKED_FLOAT32_ARRAY", "TYPE_PACKED_FLOAT64_ARRAY", "TYPE_PACKED_STRING_ARRAY", "TYPE_PACKED_VECTOR2_ARRAY", "TYPE_PACKED_VECTOR3_ARRAY", "TYPE_PACKED_COLOR_ARRAY"]
