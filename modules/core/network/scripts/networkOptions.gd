extends Control

var options:Array[Control]
enum OptionType{NUMBER, STRING, CHECK}
var optPreset = preload("res://modules/core/network/prefabs/optionPref.tscn")
var settings = {}

func addOption(opName:String, opType:OptionType, defVal):
	settings[opName] = defVal
	var l = optPreset.instantiate()
	l.name = opName
	options.append(l)
	l.setName(opName)
	l.setType(opType)
	l.setDefault(defVal)
	$main.add_child(l)
	l.custom_minimum_size = l.size

func cancel():
	for i in $main.get_children():
		i.reset()
	get_node("..").hide()

func save():
	for i in $main.get_children():
		settings[i.name] = i.getValue()
	get_tree().current_scene.get_node("network").retrieveSettings()
	get_node("..").hide()
