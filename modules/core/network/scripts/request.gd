class_name Request extends Object
enum Modes{POST, GET}
var mode:Modes
var type:String
var argv:Array

func setMode(nMode):
	mode = nMode
	return self

func setType(nType):
	type = nType
	return self

func setArg(nargv):
	argv = nargv
	return self

func _init():
	pass
