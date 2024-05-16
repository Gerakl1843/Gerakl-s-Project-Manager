extends Node

var ps

func saver():
	if ps.get_node("welcomeInterface").tabs[ps.get_node("welcomeInterface").currTab].can_save:
		ps.get_node("welcomeInterface/topMenu/mainBG/textEditTab").save()
	else: 
		ps.get_node("alerts").error("Can't save", "ERROR: No file open")

func initialize(parent):
	ps = parent
	var sc:Callable = func(): parent.get_node("welcomeInterface/topMenu").add_option("File", "Save File", 
	func():
		if ps.get_node("welcomeInterface").tabs.is_empty():
			ps.get_node("alerts").notify("Can't save", "ERROR: No file open")
			return
		if ps.get_node("welcomeInterface").tabs[ps.get_node("welcomeInterface").currTab].can_save:
			ps.get_node("welcomeInterface").tabs[ps.get_node("welcomeInterface").currTab].save()
		else: 
			ps.get_node("alerts").error("Can't save", "ERROR: No file open")
		)
	parent.queue_post_load(sc)
	parent.queue_post_load(func(): 
		parent.get_node("welcomeInterface").get_node("newTabMenu").content.addType("","Text Editor",
		func():
			var tab = load("res://modules/core/textEditor/prefabs/textEditTab.tscn").instantiate()
			tab.get_node("TextEdit").set_script(load("res://modules/core/textEditor/scripts/fancyEditor.gd"))
			tab.get_node("TextEdit").reset()
			parent.get_node("welcomeInterface").add_tab(tab)
			tab.get_node("TextEdit").users.append(get_tree().current_scene.appInstance.uSys.localUser.username)
			var desiredPath
			desiredPath = await parent.get_node("alerts").get_file("Open File...")
			if desiredPath != "":
				tab.fload(gFile.new(desiredPath, parent))
	))
	parent.queue_post_load(func():
		parent.get_node("network").requestTypes["POST:Keystroke"] = func(conn, reqw):
			if reqw["argv"][1] is Vector2i:
				get_node("textEdit").set_caret_column(get_node("textEdit").get_caret_column()+reqw["argv"][1].x, false, get_node("textEdit").users.find(reqw["argv"][0]))
				get_node("textEdit").set_caret_line(get_node("textEdit").get_caret_column()+reqw["argv"][1].y, false, get_node("textEdit").users.find(reqw["argv"][0]))
			if reqw["argv"][1] not in [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]:
				get_node("textEdit").insert_text_at_caret(OS.get_keycode_string(reqw["argv"][1]), get_node("textEdit").users.find(reqw["argv"][0]))
		)
	return 0
