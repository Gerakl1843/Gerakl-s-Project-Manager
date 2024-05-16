extends "res://modules/core/projectInterface/scripts/tab.gd"

var currFile:gFile

func _ready():
	type = "textTab"

func _process(delta):
	size = get_node("../..").av_space
	$Panel.size = self.size
	$TextEdit.size = self.size

func save():
	currFile._overwrite($TextEdit.text)

func fload(nFile:gFile):
	currFile = nFile
	$TextEdit.text = currFile._read()

func addHighliting(nSHigh:SyntaxHighlighter):
	$TextEdit.syntax_highlighter = nSHigh

