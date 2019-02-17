extends Node

var firebase
var user_data 
var host
var my_number
var room_name
var room_data

signal user_connected(user)#usuario conectado
signal user_disconneted()
signal sign_in(success)#login um sucesso
signal create_account(sucess)#se a criacao foi um sucess
signal document_added(sucess)
signal snapshot_data(data)#envia uma msg com o conteudo que foi add


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
		elif from == "Auth":
			if key =="EmailLogin":
				if data:
					user_data = parse_json(firebase.get_email_user())
					user_data["name"] = user_data["email"].split("@")[0]#corta a string tirando um caracter, e pegando apenas a primeira metade
					emit_signal("user_connected", user_data)
				else:
					user_data = null
					emit_signal("user_disconneted")
		elif from == "Firestore":
			if key == "DocumentAdded":
				emit_signal("document_added", data)
			elif key == "SnapshotData":
				emit_signal("snapshot_data", parse_json(data))
	pass

func is_connected():
	return user_data != null
	
#cria um nova list a um documento dentro de uma coleção
func set_listener(col, doc):
	firebase.set_listener(col,doc)	
	pass
func remove_listener(col, doc):
	firebase.remove_listener(col, doc)
	pass
func set_document(col, doc, data):
	firebase.set_document(col,doc, data)
	pass
