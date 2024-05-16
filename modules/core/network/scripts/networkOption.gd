extends Node

var optName:String
var optType
var default
var changed = false

func setType(type):
	match type:
		2:
			$CheckButton.show()
			$LineEdit.hide()
		_:
			$LineEdit.show()
			$CheckButton.hide()
	optType = type

func setName(newname:String):
	optName = newname
	$optName.text = newname

func getValue():
	if optType == 2:
		return $CheckButton.button_pressed
	else:
		return $LineEdit.text

func setValue(val):
	if optType == 2:
		$CheckButton.button_pressed = val
	else:
		$LineEdit.text = val

func setDefault(def):
	default = def
	if !changed:
		if optType == 2:
			$CheckButton.button_pressed = def
		else:
			$LineEdit.text = def

func reset():
	setValue(default)
