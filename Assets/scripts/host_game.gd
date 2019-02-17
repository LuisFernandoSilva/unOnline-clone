extends Control

enum {CREATE, WAIT,START} #criao enum pra controlar os estados de criaçao da sala
var state = CREATE
var room_data #guarda os datos do snapshot
var user_data

func _ready():
	game_state.host = true
	game_state.my_number = 0
	user_data = game_state.user_data
	game_state.room_name = user_data["name"]
	
	game_state.connect("document_added", self, "_on_document_added")
	game_state.connect("snapshot_data", self, "_on_snapshot_data")
	
	$Panel/label_host.text = "Criando sala..."
	#cria no bd a coleçao rooms com dados em em json
	game_state.set_document("rooms", game_state.room_name, {"players":{"0":user_data["name"]}, "state": "open"})
	
	pass
	
func _on_document_added(sucess):
	if state == CREATE:
		if sucess:
			print("Sala criada com sucesso")
			$Panel/label_host.text = "Seus amigos devem dar join em \""+user_data["name"] + "\"!"
			game_state.set_listener("rooms", game_state.room_name)
			state= WAIT
		else:
			print("Falha na criação")
			get_tree().change_scene("res://Assets/scenes/main_game.tscn")
	pass
	
func _on_snapshot_data(data):
	room_data = data
	if state == WAIT:
		print("Alteração nos jogadores")
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
	elif state == START:#caso receba o start guarda os dados 
		game_state.room_data = room_data
		#muda pra tela de jogo
		pass



func _on_btn_start_pressed():
	#muda o estado documento da coleçao rooms no firebase
	room_data["state"] = "start"
	game_state.set_document("rooms", game_state.room_name, room_data)
	#muda o estado par ase iniciar a partida
	state = START 
	pass 


func _on_btn_cancel_pressed():
	room_data["state"] = "cancel"
	game_state.remove_listener("rooms", game_state.room_name)
	game_state.set_document("rooms", game_state.room_name, room_data)
	get_tree().change_scene("res://Assets/scenes/main_game.tscn")
	
	pass 
