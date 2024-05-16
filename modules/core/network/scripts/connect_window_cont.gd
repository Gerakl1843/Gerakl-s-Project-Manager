extends Control

@onready var network = get_tree().current_scene.get_node("network")

func cancel():
	get_node("..").hide()

func connectToHost():
	network.initCon($IP.text, int($Port.text))
	get_node("..").hide()
