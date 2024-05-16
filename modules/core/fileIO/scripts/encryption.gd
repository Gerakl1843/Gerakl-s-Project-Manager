class Cryptography:
	var	crypto = Crypto.new()
	var crKey:CryptoKey
	
	func _init():
		if FileAccess.file_exists("usr://crkey.key"):
			load_key()
		else:
			generate_key()
	
	func _encrypt(text:String):
		return crypto.encrypt(crKey, text.to_utf8_buffer())

	func _decrypt(enc_text):
		return crypto.decrypt(crKey, enc_text).get_string_from_utf8()
	
	func generate_key():
		crKey = crypto.generate_rsa(4096)
		crKey.save("user://crkey.key")

	func load_key(loc = "user://crkey.key"):
		crKey.load(loc)
