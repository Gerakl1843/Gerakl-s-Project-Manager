extends Control

var bootloader
var res = Vector2(1152, 686)
var dragged = false
var cDragged = false
var tabs:Array[Control]
var tabScene = preload("res://modules/core/projectInterface/prefabs/tabButton.tscn")
var currTab:int = 0
const OFFSET = 32
var av_space = Vector2.ZERO

func _process(_delta):
	$topBar/appName.text = bootloader.appInstance.get_name() + " v" + bootloader.appInstance.get_version()
	$topBar.size = Vector2(get_window().size.x, OFFSET)
	$mainBg.size = get_window().size
	$topBar/close.position.x = $topBar.size.x - OFFSET
	$topBar/fullscreen.position.x = $topBar.size.x - 2*OFFSET
	$topBar/minimize.position.x = $topBar.size.x - 3*OFFSET
	$bottomMenu.position.y = get_window().size.y - 1.25*OFFSET
	av_space = Vector2(get_window().size.x, get_window().size.y - $topBar.size.y - $bottomMenu.size.y - $topMenu.size.y)

func _input(event):
	if dragged:
		if event is InputEventMouseMotion:
			get_window().position += Vector2i(event.relative)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if cDragged and event.pressed == true:
				dragged = true
			else:
				dragged = false

# TODO: Ask if user wants to save.
func close():
	get_tree().quit()

func fullscreen():
	if get_window().mode == Window.MODE_FULLSCREEN:
		get_window().mode = Window.MODE_WINDOWED
	else: 
		get_window().mode = Window.MODE_FULLSCREEN

func minimize():
	get_window().mode = Window.MODE_MINIMIZED

func can_drag():
	cDragged = true

func cant_drag():
	cDragged = false

func add_tab(tab:Control):
	tab.id = len(tabs)
	currTab = tab.id
	tabs.append(tab)
	$mainBg.add_child(tab)
	tab.position.y += 2*OFFSET
	var tb = $bottomMenu.addTab(tab.name, tab.id)
	tb.switched.connect(update_tabs)
	tb.closed.connect(remove_tab)
	update_tabs(tab.id)

func remove_tab(id:int):
	tabs[id].queue_free()
	tabs.remove_at(id)
	var li:Array[Control] = []
	for i in tabs:
		i.id = len(li)
		li.append(i)
	tabs = li
	li = []
	for i in $bottomMenu.tbButtons:
		i.id = len(li)
		li.append(i)
	$bottomMenu.tbButtons = li
	$bottomMenu.removeTab(id)
	update_tabs(id-1)

func update_tabs(id:int):
	if tabs.is_empty():
		return
	tabs[currTab].hide()
	tabs[id].show()
	currTab = id

func newTab():
	$newTabMenu.popup()
