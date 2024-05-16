extends MenuButton

@export_multiline var menuFunctions:Dictionary = {}

func _ready():
	for i in menuFunctions.keys():
		if menuFunctions[i] is String:
			var expr = Expression.new()
			if expr.parse(menuFunctions[i]) == OK:
				menuFunctions[i] = expr
			else:
				get_tree().current_scene.get_node("alerts").error("Couldn't load menus",
				"Sorry, there's been an error setting up menus.\nRestart the app, and if \
				the problem perstists,\nreinstall the program or contact the developer."\
				)
	for i in menuFunctions.keys():
		get_popup().add_item(i)
	get_popup().id_pressed.connect(choice)

func choice(id:int):
	if menuFunctions.values()[id] is Expression:
		menuFunctions.values()[id].execute([], self)
	else:
		menuFunctions.values()[id].call()
