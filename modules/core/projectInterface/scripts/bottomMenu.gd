extends Control

var tbButtons = []
var btnScene = load("res://modules/core/projectInterface/prefabs/tabButton.tscn")
var tabs = []
var currIdx

func addTab(title:String, idx = -1):
	var l:Control = btnScene.instantiate()
	l.custom_minimum_size = l.size
	l.get_node("Label").text = title
	l.name = title
	add_child(l)
	tabs.insert(idx, l)
	return l

func removeTab(idx:int = -1):
	tabs[idx].queue_free()
	tabs.remove_at(idx)
