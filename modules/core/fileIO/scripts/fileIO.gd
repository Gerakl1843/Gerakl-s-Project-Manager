extends Node

var externalApplications:Dictionary
var cryptoInstance
var fileDesc = FileDescriptor.new()
var nParent


func initialize(parent):
	cryptoInstance = load("res://modules/core/fileIO/scripts/encryption.gd").new()
	if cryptoInstance == null:
		return -1
	if FileAccess.file_exists("user://programPreferences.json"):
		var f = FileAccess.open("user://programPreferences.json", FileAccess.READ)
		if f.get_as_text() != "":
			externalApplications = JSON.parse_string(f.get_as_text())
		f.close()
	else:
		FileAccess.open("user://programPreferences.json", FileAccess.WRITE_READ).close()
	nParent = parent
	return 0


func create(path):
	FileAccess.open(path, FileAccess.WRITE_READ).close()


func exists(file:gFile):
	return FileAccess.file_exists(file.path)


func read(file:gFile):
	return cryptoInstance._decrypt(file._get_raw())


func write(file:gFile, content:String):
	file._write(cryptoInstance._encrypt(content))


func open_external(file:gFile):
	if fileDesc.typeHints.keys().has(file.type):
		var cl = OS.execute
		cl.bind(externalApplications[fileDesc.typeHints[file.type]], [file.path])
		var t = Thread.new()
		t.start(cl, Thread.PRIORITY_NORMAL)
		await t.wait_to_finish()
	else:
		nParent.get_node("alerts").notify("No external app", "No external application has been selected to open this file. Please set one in Settings->External Editors.")
