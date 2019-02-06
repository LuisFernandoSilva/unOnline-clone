extends Node

var firebase

func _ready():
	firebase = Engine.get_singleton("FireBase")
	firebase.initWithFile("res://godot-firebase-config.json", get_instance_id())


