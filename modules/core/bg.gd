extends Panel

var maxStartuplen:int = 6


func _process(_delta):
	if $progressText.text.count("\n") > maxStartuplen:
		$progressText.text.replace($progressText.text.split("\n")[0], "")
