class_name Project

var project_name:String
var project_dir:String

func newProject(nname:String, ndir:String):
	project_name = nname
	project_dir = ndir
	return self

func open(ndir):
	project_dir = ndir
	if FileAccess.file_exists(project_dir+"/project.gpj"):
		var cfg = ConfigFile.new()
		cfg.load(project_dir + "/project.gpj")
		project_name = cfg.get_value("Project", "Name")
	return self

func generate_project_files(obj:Node):
	if project_dir != "":
		obj.get_tree().current_scene.get_node("fileIO").create(project_dir+"/project.gpj")
		var cfg = ConfigFile.new()
		cfg.set_value("Project", "Name", project_name)
		cfg.set_value("Project", "Directory", project_dir)
		cfg.save(project_dir+"/project.gpj")
