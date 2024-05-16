class_name App

# Initialise basic app infp
var appName = "GProject Manager"
var version = "0.0.1.5"
var core_modules = {
	"core/alerts":"res://modules/core/alerts/scripts/alerts.gd",
	"core/fileIO":"res://modules/core/fileIO/scripts/fileIO.gd",
	"core/projectInterface":"res://modules/core/projectInterface/scripts/projectInterface.gd",
	"core/textEditor":"res://modules/core/textEditor/scripts/textEditor.gd",
	"core/network":"res://modules/core/network/scripts/network.gd"
	}
var appdir:String = ""
var uSys:userSystem = userSystem.new()
var parent

var tempMem = {}


func loadLocalUser():
	if FileAccess.file_exists("user://local.dat"):
		var fl = ConfigFile.new()
		if fl.load("user://local.dat") == OK:
			uSys.localUser = User.new(fl.get_value("USERDATA", "username"), fl.get_value("USERDATA", "avatarpath"), uSys)
	else:
		uSys.localUser = User.new("User", "res://", uSys)


func get_version():
	return version


func get_name():
	return appName

# Call module.initialize()
func initialize(script:String, parent):
	var n = Node.new()
	parent.add_child(n)
	n.name = script.split("/")[-1].split(".")[0]
	n.set_script(load(script))
	return n.initialize(parent)

# Load built-in functionality
func _load_core_modules(parent):
	self.parent = parent
	get_app_dir()
	var failed = []
	for i in core_modules.keys():
		if initialize(core_modules[i].replace("app:/", appdir), parent) != 0:
			if i == "core/alerts":
				return 1
			failed.append(i)
		parent.get_node("bg/progressText").text += "Loading " + i + "...\n"
		parent.get_node("bg/progressBar").value += parent.get_node("bg/progressBar").max_value / core_modules.keys().size()
	loadLocalUser()
	if !failed.is_empty():
		return [2, failed]
	else:
		return 0

# Update installation directory
func get_app_dir():
	appdir = OS.get_executable_path().get_base_dir()
