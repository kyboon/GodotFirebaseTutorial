## Cloud save update
Please note that due to a major update from the GodotFirebase, some changes has been made to the Game.gd code in *Completed project*. More details from GodotFirebase repo: https://github.com/GodotNuts/GodotFirebase/wiki/Upgrade-Guide-to-4.x-version-2#upgrade-guide

### Old code
func save_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var panda_name = %PandaNameLineEdit.text
		var data: Dictionary = {
			"panda_name": panda_name,
			"petting_count": petting_count
		}
		var task: FirestoreTask = collection.update(auth.localid, data)

func load_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc(auth.localid)
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.panda_name:
				%PandaNameLineEdit.text = document.doc_fields.panda_name
			if document.doc_fields.petting_count:
				petting_count = document.doc_fields.petting_count
		else:
			print(finished_task.error)

### New code
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