extends Control

var refMem

@onready var tree:Tree = get_node("types")

var typeStruct = {
	"root":{
		
	}
}

var typeShortHand = {}

var selectedItem:Vector2

func _ready():
	tree.hide_root = true

# Path format: path/to/category. If path reveals non-category, return -1
func addType(path:String, ntype:String, nTypeCont:Callable):
	var l = typeStruct["root"]
	if path != "":
		for i in path.split("/"):
			l = l[i]
	if l is Dictionary:
		l[ntype] = nTypeCont
		typeShortHand[ntype] = path
		update_tree()
		return 0
	else:
		return -1

func addCategory(path:String, ntype:String):
	var l = typeStruct["root(invisible)"]
	for i in path.split("/"):
		l = l[i]
	if l is Dictionary:
		l[ntype] = {}
		update_tree()
		return 0
	else:
		return -1

# executeOnAll causes function to be executed on all members of the structure, otherwise only non-categories are affected.
func traverseStructureRecursive(tree:Dictionary, executeFunc:Callable, executeOnAll:bool = false):
	for i in tree.keys():
		if tree[i] is Dictionary:
			if executeOnAll:
				executeFunc.call(i, tree[i])
			traverseStructureRecursive(tree[i], executeFunc, executeOnAll)
		else:
			executeFunc.call(i, tree[i])

func update_tree():
	refMem = {}
	traverseStructureRecursive(typeStruct, 
	(func(nam, obj):
		var a:TreeItem
		refMem = []
		if refMem.is_empty():
			a = tree.create_item()
		else:
			a = tree.create_item(refMem[-1])
		a.set_text(0, nam)
		if obj is Dictionary:
			if obj.keys().has("content"):
				a.disable_folding = true
				a.set_cell_mode(0, TreeItem.CELL_MODE_CUSTOM)
				a.set_icon(0, load(obj["content"]["icon"]))
				)
	, true)
	pass

func selected(position, mouse_button_index):
	selectedItem = position

func close():
	get_node("..").hide()

func create():
	var l = typeStruct["root"]
	var s = tree.get_item_at_position(selectedItem).get_text(0)
	if typeShortHand[s] != "":
		for i in typeShortHand[s].split("/"):
			l = l[i]
	l[s].call()
	get_node("..").hide()
