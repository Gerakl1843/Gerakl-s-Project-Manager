class_name gFile

var path:String = ""
var type:FileDescriptor.coreFileTypes
var currScene:Control

func _init(npath:String, sc:Control):
	path = npath
	for i in FileDescriptor.new().typeHints.keys():
		if FileDescriptor.new().typeHints[i] == path.split(".")[-1]:
			type = i
	currScene = sc

func _get_raw():
	return FileAccess.open(path, FileAccess.READ).get_as_text()

func _read():
	if path == "" or !FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND
	else:
		#return currScene.get_node("fileIO").read(self)
		return _get_raw()

func _write(what:String):
	if path == "" or !FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND
	else:
		currScene.get_node("fileIO").write(self, what)
		return OK


func _overwrite(what:String):
	if path == "" or !FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND
	else:
		#currScene.get_node("fileIO")._overwrite(self, what)
		FileAccess.open(path, FileAccess.WRITE).store_string(what)
		return OK
