extends Control


func _ready():
	game_state.connect("user_connected", self,"_on_user_connected")#conecta com o sinal, neste script, usando essa função
	game_state.connect("create_account", self,"_on_create_account")
	game_state.connect("sign_in", self,"_on_sign_in")
	
	pass

func _on_user_connected(user):
	$Panel/label_info.text = "Conectado!"
	get_tree().change_scene("res://Assets/scenes/main_game.tscn")
	pass
	
func _on_create_account(sucess):
	if not sucess:
		$Panel/label_info.text = "Falha ao criar login!"
		set_all(true)
	pass
	
func _on_sign_in(sucess):
	if not sucess:
		$Panel/label_info.text = "Falha ao logar!"
		set_all(true)
	pass




func _on_btn_sign_pressed():
	#var user_name = get_node("Panel/user_name").get_text() para a versao 2.15
	var user_name = $Panel/user_name.text #para a versao 3.0
	var password = $Panel/password.text
	if user_name.empty() or password.empty():
		$Panel/label_info.text = "Preencha todos os Campos"
		return
	$Panel/label_info.text = "Conectando..."
	game_state.login(user_name+"@unonlineclone.com", password)
	set_all(false)
	
	pass 


func _on_btn_sign_up_pressed():
	var user_name = $Panel/user_name.text #para a versao 3.0
	var password = $Panel/password.text
	if user_name.empty() or password.empty():
		$Panel/label_info.text = "Campos invalidos"
		return
	$Panel/label_info.text = "Criando..."
	game_state.create_user(user_name+"@unonlineclone.com", password)
	set_all(false)
	
	pass 
	
func set_all(state):
	$Panel/user_name.editable = state
	$Panel/password.editable = state
	$Panel/btn_sign_up.disabled = not state
	$Panel/btn_sign.disabled = not state
	
	
	pass


