extends Control



func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass




func _on_btn_host_pressed():
	pass # replace with function body


func _on_btn_join_pressed():
	pass # replace with function body


func _on_btn_signOut_pressed():
	game_state.sign_out()
	get_tree().change_scene("res://Assets/scenes/login.tscn")
	
	pass 
