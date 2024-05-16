extends Node


var message = AcceptDialog.new()
var confirmation = ConfirmationDialog.new()
var fileDialog = FileDialog.new()
var confRes = 0
var file = ""

func initialize(parent):
	parent.add_child(message)
	parent.add_child(confirmation)
	parent.add_child(fileDialog)
	fileDialog.position = Vector2(600, 600)
	message.position = Vector2(600, 600)
	confirmation.position = Vector2(600, 600)
	fileDialog.file_selected.connect(fileChosen)
	fileDialog.access = FileDialog.ACCESS_FILESYSTEM
	fileDialog.get_cancel_button().pressed.connect(cancelled)
	return 0


func notify(title:String, what:String):
	message.title = title
	message.dialog_text = what
	message.popup()


func confirm(title:String, what:String, okText:String, cancelText:String):
	confirmation.title = title
	confirmation.dialog_text = what
	confirmation.get_cancel_button().text = cancelText
	confirmation.get_ok_button().text = okText
	confirmation.popup()
	if confRes == 1:
		confRes = 0
		return true
	elif confRes == -1:
		confRes = 0
		return false

func cancelled():
	fileDialog.emit_signal("file_selected", "")

func fileChosen(path):
	file = path

func get_file(title):
	fileDialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fileDialog.title = title
	fileDialog.popup()
	await fileDialog.file_selected
	return file
