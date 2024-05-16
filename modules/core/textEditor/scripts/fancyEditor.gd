extends TextEdit

var colors = [Color.DARK_ORCHID, Color.ORANGE, Color.CRIMSON, Color.GREEN]
var blinkProgression = 0.65
var blinkInterval = 0.65
@export var nameToggleButton = KEY_ALT
var keys = []
var users = []


func reset():
	add_theme_color_override("caret_background_color", Color.TRANSPARENT)
	add_theme_color_override("caret_color", Color.TRANSPARENT)
	get_v_scroll_bar().value_changed.connect(func(value:float): queue_redraw())
	set_tab_size(4)
	add_theme_font_size_override("font_size", 20)


func _process(delta):
	blinkProgression -= delta
	if blinkProgression <= 0:
		blinkProgression = blinkInterval
	queue_redraw()

func _input(event):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_CTRL):
			if !event.pressed:
				if event.keycode == KEY_MINUS:
					add_theme_font_size_override("font_size", get_theme_font_size("font_size") - 2)
				elif event.keycode == KEY_EQUAL:
					add_theme_font_size_override("font_size", get_theme_font_size("font_size") + 2)
		else:
			if !event.pressed:
				if event.keycode not in [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]:
					for i in get_node("../../../..").get_node("network").tcpConnections:
						i.put_var({"mode":"POST", "type":"Keystroke", "argv":[get_node("../../../..").appInstance.uSys.localUser.username, event.keycode]})
				else:
					for i in get_node("../../../..").get_node("network").tcpConnections:
						i.put_var({"mode":"POST", "type":"Keystroke", "argv":[get_node("../../../..").appInstance.uSys.localUser.username, Vector2i(int(Input.is_key_pressed(KEY_RIGHT)) - int(Input.is_key_pressed(KEY_LEFT)), int(Input.is_key_pressed(KEY_DOWN)) - int(Input.is_key_pressed(KEY_UP)))]})

func _draw() -> void:
	for i in range(get_caret_count()):
		var pos = get_caret_draw_pos(i)
#		if pos.x == 0:
#			pos += Vector2(2, 12)
		pos.y -= 3
		var cl = colors[i % colors.size()]
		cl.a *= (blinkProgression / 0.65)
		draw_line(pos, pos - Vector2(0, get_theme_font_size("font_size")+3), cl, 2)
