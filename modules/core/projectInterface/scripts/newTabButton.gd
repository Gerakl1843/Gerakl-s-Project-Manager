extends Control

signal newTab

func _on_new_pressed():
	emit_signal("newTab")
