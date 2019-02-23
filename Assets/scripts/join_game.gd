extends Control

enum {CONNECT, WAIT}
var state = CONNECT
var room_data

func _ready():
	game_state.host = false
	game_state.connect("snapshot_data", self, "_on_snapshot_data")
	
	
	
	pass
	
func _on_snapshot_data(data):
	room_data = data
	if state == CONNECT:
		if room_data == null or room_data["state"] != "open":
			$Panel/btn_ok.disabled = true
			$Panel/host_edit.editable = false
			$Panel/host_edit.text = ""
			$Panel/host_edit.placeholder_text = "name incorrect"
			game_state.remove_listener("rooms", game_state.room_name)
			return
		if room_data["state"] == "open":
			#faz o for in para verificar se tem espaço no array
			for i in range(4):
				#se nao tem o player na posiçao que  esta o i entao inclui este
				if not room_data["players"].has(str(i)):
					room_data["players"][str(i)] = game_state.user_data["name"]
					game_state.my_number = i
					state = WAIT
					#salva o que foi feito no documento no firebase
					game_state.set_document("rooms", game_state.room_name, room_data)
					break
	elif state == WAIT:
			print("alteração nos jogadores")
			var n_players = room_data["players"].size() #informa o tamanho da lista
			$Panel/label_players.text = "Players "+str(n_players)+"/4:"
			#faz um for para percorrer o array de players
			for i in range (4):
			#se dentro do documento players tem o i convertido em string
				if room_data["players"].has(str(i)): 
					#acessa cada uma das labels conforme faz o for e add o nome se tiver na lista
					get_node("Panel/label_player_"+str(i)).text = room_data["players"][str(i)] 
				else:
					get_node("Panel/label_player_"+str(i)).text = "-"
					#se o numero de player for maior ou igual a um habilida o start
					$Panel/btn_start.disabled = (n_players <=1)
				
			if room_data["state"] == "start":
					game_state.room_data = room_data
					#muda pra tela de jogo
				
			elif room_data["state"] == "cancel":
					game_state.remove_listener("rooms", game_state.room_name)
					get_tree().change_scene("res://Assets/scenes/main_game.tscn")
	pass

func _on_btn_ok_pressed():
	game_state.room_name = $Panel/host_edit.text
	game_state.set_listener("rooms", game_state.room_name)
	$Panel/btn_ok.disabled = true
	$Panel/host_edit.editable = false
	
	
	pass 


func _on_btn_cancel_pressed():
	if state == WAIT:
		room_data["players"].erase(str(game_state.my_number))
		game_state.remove_listener("rooms", game_state.room_name)
		game_state.set_document("rooms", game_state.room_name, room_data)
	get_tree().change_scene("res://Assets/scenes/main_game.tscn")
	
	
		
	pass 
