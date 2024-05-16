class_name userSystem

var uids:Dictionary
var localUser:User

func issueNewUID(userObject:User):
	var a = 0
	while true:
		if a in uids:
			a += 1
		else:
			userObject.userID = a
			uids[a] = userObject
			return a

func getUserByID(id:int):
	return uids[id]

func getUserByName(username:String):
	for i in uids.keys():
		if uids[i].username == username:
			return uids[i]
	return null
