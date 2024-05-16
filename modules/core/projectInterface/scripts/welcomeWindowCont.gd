extends Control

var fileChoice = FileDialog.new()
var filePath
var pName

func _ready():
	fileChoice.access = FileDialog.ACCESS_FILESYSTEM
	fileChoice.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	add_child(fileChoice)
	fileChoice.dir_selected.connect(fileChosen)

func newProj():
	fileChoice.popup()
	await fileChoice.dir_selected
	await $prName/Button.pressed
	get_tree().current_scene.get_node("projectInterface").currProject = Project.new().newProject($prName.text, filePath)
	get_tree().current_scene.get_node("projectInterface").currProject.generate_project_files(self)
	get_window().hide()

func openProj():
	fileChoice.popup()
	await fileChoice.dir_selected
	get_tree().current_scene.get_node("projectInterface").currProject = Project.new().open(filePath)
	get_window().hide()

func fileChosen(path):
	filePath = path
