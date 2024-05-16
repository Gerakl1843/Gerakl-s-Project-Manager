extends Control

var appInstance:App
var post_load_queue:Array[Callable]
var loaded_files:Array[gFile]

func _ready():
	appInstance = App.new()
	var loadSt = appInstance._load_core_modules(get_tree().current_scene)
	if loadSt == 1:
		get_tree().quit(1)
	elif loadSt == 0:
		execute_post_load()

func queue_post_load(queue_item:Callable):
	post_load_queue.append(queue_item)

func execute_post_load():
	for i in post_load_queue:
		i.call_deferred()

func load_file(path):
	var f = gFile.new(path, get_tree().current_scene)
	loaded_files.append(f)
	return f

func update_fileData():
	for i in loaded_files:
		i.currScene = self
