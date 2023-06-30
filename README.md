# Godot ThingEditor Plugin

ThingEditor is a custom control node which serves to provide boilerplate management for mapping UI editing fields to an Object's ("Thing's") properties.

<br>

#### What can ThingEditor edit? 
### Any*thing*!

<br>

## Installation

### 1. Zip Download

Download the latest release, Out of the zipped contents, move the addons folder to your project folder, and enable the plugin.
An example scene is included if you'd like to see it in action first.

### 2. Git Submodule

Clone the repo into your project's `addons` folder.

<br>

## Usage

1. Create a `ThingEditor` node.
2. Add desired `Controls`s as children of the `ThingEditor`.
   - **Note:** ThingEditor does not do any generation. It is up to the user what properties are editable where.
3. Provide the `ThingEditor` with an example `thing`. This can be a resource local instance, or a reference to a saved "default" instance.
4. Populate the `property_sources` array.
	- Each `PropertySource` requires four things:
		1. `property_name`
			- The name of the property within `thing` that this `PropertySource` is responsible for.
		2. `node_path`
			- The path to the UI Field associated with this property.
		3. `node_submission_signal`
			- The signal possesed by the node at `node_path` that will trigger an update of `thing`.`property_name`
		4. `node_source_property_name`
			- The property of the node at `node_path` that will be read to get the new value.
5. Call `ThingEditor`.`load_thing()` at runtime to load an instance to be edited.

<br>

## Flexibility

The following are a few considerations about the flexibility that `ThingEditor` provides:

- A given `ThingEditor` is not required to provide a field for every property.
- A given `ThingEditor` can provide a PropertySource for a property the current object instance does not posses.
	- In this situation, `ThingEditor` will automatically disable all fields associated with non-existent properties. (NOT YET IMPLEMENTED_
- Multiple `ThingEditor`s can be responsible for a single object instance.
- `ThingEditor` can be extended to override functionality.

<br>

## Upcoming

- Functionality to disable fields associated with non-existent properties.
- Functionality for generation of lists (for editing properties that are `Array`s).