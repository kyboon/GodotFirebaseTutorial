extends Control

var COLLECTION_ID = "panda_stats"

var petting_count: int = 0:
	set(value):
		petting_count = value
		%PettingCountLabel.text = str(value)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_panda_button_pressed():
	petting_count += 1


func _on_logout_button_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://Authentication.tscn")


func _on_save_button_pressed():
	save_data()
	
func save_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var panda_name = %PandaNameLineEdit.text
		var data: Dictionary = {
			"panda_name": panda_name,
			"petting_count": petting_count
		}
		var document = await collection.get_doc(auth.localid)
		if document:
			print("Document exist, update it")
			await collection.update(FirestoreDocument.new(data))
		else:
			print("Document not exist, add new")
			await collection.add(auth.localid, data)

func load_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var document = await collection.get_doc(auth.localid)
		if document:
			if document.get_value("panda_name"):
				%PandaNameLineEdit.text = document.get_value("panda_name")
			if document.get_value("petting_count"):
				petting_count = document.get_value("petting_count")
		elif document:
			print(document.error)
		else:
			print("No document found")
	
