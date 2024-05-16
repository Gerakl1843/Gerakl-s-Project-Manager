extends Node

var targetRes:Vector2 = Vector2(1152, 686)
var targetPos:Vector2 = Vector2(160, 90)
var currProject:Project

func initialize(parent):
	var scL  = func ():
		get_window().size = targetRes
		get_window().position = targetPos
		var sc = load("res://modules/core/projectInterface/prefabs/welcomeInterface.tscn").instantiate()
		parent.add_child(sc)
		sc.name = "welcomeInterface"
		sc.bootloader = parent
		parent.get_node("bg").queue_free()
	parent.queue_post_load(scL)
	return 0
