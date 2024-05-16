extends Node

var tcpConnections:Array[StreamPeerTCP]
var tcpPeer:StreamPeerTCP
var server:TCPServer
var peers:Dictionary
var port = 443
var req = Request
var lock = false
var ext_ip
var mainNode
var cnt = 0
var requestTypes = {
	"GET:user": func(conn, reqw):
		conn.put_var({"mode":"GET", "type":"user", "argv":[ext_ip+":"+str(port), mainNode.appInstance.uSys.localUser]}),
	"POST:user": func(conn, reqw):
		if reqw["argv"][0] in peers:
			pass
		else:
			peers[reqw["argv"][0]] = reqw["argv"][1]
			if get_tree().current_scene.get_node("welcomeInterface").tabs[get_tree().current_scene.get_node("welcomeInterface").currTab].type == "textTab":
				get_tree().current_scene.get_node("welcomeInterface").tabs[get_tree().current_scene.get_node("welcomeInterface").currTab].get_node("TextEdit").users.append(reqw["argv"][1].username)
				get_tree().current_scene.get_node("welcomeInterface").tabs[get_tree().current_scene.get_node("welcomeInterface").currTab].get_node("TextEdit").add_caret(0,0),
	"GET:peers": func(conn, reqw):
		conn.put_var({"mode":"POST", "type":"peers", "argv":[ext_ip+":"+str(port), mainNode.appInstance.uSys.localUser]}),
	"POST:peers": func(conn, reqw):
		for i in reqw["argv"][0].keys():
			if i in peers:
				pass
			else:
				peers[i] = reqw["argv"][0][i]
}

# Software is client - client; It shouldn't be used for server creation
func initialize(parent):
	tcpPeer = StreamPeerTCP.new()
	server = TCPServer.new()
	server.listen(port)
	var upnp = UPNP.new()
	upnp.discover()
	ext_ip = upnp.query_external_address()
	mainNode = parent
	parent.queue_post_load(func():
		parent.get_node("welcomeInterface/NetwSettWindow/NetworkInterface").addOption("Port", 1, "433")
		parent.get_node("welcomeInterface/NetwSettWindow/NetworkInterface").addOption("Username", 1, "User")
		parent.get_node("welcomeInterface/topMenu").add_option("Edit", "Network", 
		func():
			parent.get_node("welcomeInterface/NetwSettWindow").show()
			))
	parent.queue_post_load(func():
		parent.get_node("welcomeInterface/topMenu").add_option("Edit", "Connect", 
		func():
			parent.get_node("welcomeInterface/ConnectWindow").show()
		)
	)
	set_process(true)
	return 0

func _process(_delta):
	for i in tcpConnections:
		i.poll()
	if cnt > 10:
		queryCon()
		resolveReq()
		cnt = 0
	else:
		cnt += 1

func retrieveSettings():
	port = int(mainNode.get_node("welcomeInterface/NetwSettWindow/NetworkInterface").settings["Port"])
	server.stop()
	server.listen(port)
	mainNode.appInstance.uSys.localUser.username = mainNode.get_node("welcomeInterface/NetwSettWindow/NetworkInterface").settings["Username"]
	

func queryCon():
	if server.is_connection_available():
		if !lock:
			tcpPeer = server.take_connection()
			lock = true
			await resolveConnection()

func resolveReq():
	for i in tcpConnections:
		if i.get_status() == 0 or i.get_status() == 3:
			peers.erase(i.get_connected_host()+":"+str(i.get_connected_port()))
			i.disconnect_from_host()
			continue
		if i.get_status() == 1:
			continue
		if i.get_available_bytes() > 0:
			print("REQUEST")
			var request = i.get_var(true)
			if request["mode"] == "GET":
				for j in requestTypes.keys():
					if j.split(":")[1] == request["type"] and j.split(":")[0] == "GET":
						print("a")
						requestTypes[j].call(i, request)
			elif request.mode == "POST":
				for j in requestTypes.keys():
					if j.split(":")[1] == request["type"] and j.split(":")[0] == "POST":
						print("b")
						requestTypes[j].call(i, request)

func resolveConnection():
	tcpPeer.put_var({"mode":"GET", "type":"user"})
	tcpConnections.append(tcpPeer)
#	tcpPeer.put_var(req.new(req.Modes.GET, "peers"), true)
	lock = false

func initCon(ip, port):
	var c = StreamPeerTCP.new()
	if c.connect_to_host(ip, port) == OK:
		tcpConnections.append(c)
		c.poll()
		c.put_var({"mode":"GET", "type":"user"})
#		c.poll()
#		c.put_var(req.new(req.Modes.GET, "peers"))
	else:
		mainNode.get_node("alerts").notify("Cannot connect", "ERROR: Cannot resolve host:port.")
	
func goOffline():
	for i in tcpConnections:
		i.disconnect_from_host()
	tcpConnections.clear()
