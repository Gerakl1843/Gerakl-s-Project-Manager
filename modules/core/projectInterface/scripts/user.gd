class_name User

var username:String
var userID:int
var userAvatarFile:String

func _init(uname, uAvFile, uSys:userSystem):
	username = uname
	userID = uSys.issueNewUID(self)
	userAvatarFile = uAvFile
