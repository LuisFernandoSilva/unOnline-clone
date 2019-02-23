extends Control

func _ready():
	
	pass

func _on_btn_host_pressed():
	get_tree().change_scene("res://Assets/scenes/host_game.tscn")
	pass


func _on_btn_join_pressed():
	get_tree().change_scene("res://Assets/scenes/join_game.tscn")
	pass 


func _on_btn_signOut_pressed():
	game_state.sign_out()
	get_tree().change_scene("res://Assets/scenes/login.tscn")
	
	pass 
