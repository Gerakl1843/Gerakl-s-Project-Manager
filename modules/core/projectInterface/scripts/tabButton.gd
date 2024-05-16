extends Control

var id:int = 0
signal closed(id:int)
signal switched(id:int)
var can_switch:bool = false

func clsd():
	emit_signal("closed", id)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !event.pressed:
				if can_switch:
					emit_signal("switched", id)

func selected():
	can_switch = true

func deselected():
	can_switch = false
