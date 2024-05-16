extends HBoxContainer

var drScript = preload("res://modules/core/projectInterface/scripts/dropdown.gd")
@export_multiline var sections:Dictionary

func add_section(section_name:String, section_content:Dictionary):
	sections[section_name] = section_content
	reload_sections()

func add_option(section_name:String, option_name:String, option_content):
	sections[section_name][option_name] = option_content
	reload_sections()

func remove_options(section_name:String, option_name):
	sections[section_name].erase(option_name)
	reload_sections()

func remove_section(section_name):
	sections.erase(section_name)
	reload_sections()

func _ready():
	reload_sections()

func reload_sections():
	for i in get_children():
		i.queue_free()
	for i in sections.keys():
		var l = MenuButton.new()
		l.name = i
		l.text = i
		l.set_script(drScript)
		l.menuFunctions = sections[i]
		add_child(l)
		
