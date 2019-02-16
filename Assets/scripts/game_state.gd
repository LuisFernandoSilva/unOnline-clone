extends Node

var firebase
var user_data 

signal user_connected(user)#usuario conectado
signal user_disconneted()
signal sign_in(success)#login um sucesso
signal create_account(sucess)#se a criacao foi um sucess


func _ready():
	firebase = Engine.get_singleton("FireBase")
	firebase.initWithFile("res://godot-firebase-config.json", get_instance_id())
	pass
	
func create_user(email, password):
	firebase.email_create_account(email,password)

func login(email, password):
	firebase.email_sign_in(email, password)
	pass

func sign_out():
	firebase.email_sign_out()
	pass

func _receive_message(tag,from,key,data):
	if tag == "FireBase":
		if from == "E&P":
			if key == "SignIn":
				emit_signal("sign_in", data) #retorna um boleano para o sinal
			elif key == "CreateAccount":
				emit_signal("create_account",data)
		elif from == "EmailLogin":
			if data:
				user_data = parse_json(firebase.get_email_user())
				emit_signal("user_connected", user_data)
			else:
				user_data = null
				emit_signal("user_disconneted")
	pass

func is_connected():
	return user_data != null
