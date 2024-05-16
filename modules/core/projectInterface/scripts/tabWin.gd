extends Window

@onready var content = $newTabMenuContent


func _on_close_requested():
	hide()
