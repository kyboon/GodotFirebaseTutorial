extends Control

var player_status: Dictionary = {}
var player_id = ""
var db_ref = Firebase.Database.get_database_reference("player_status")
# Called when the node enters the scene tree for the first time.
func _ready():
	player_id = Firebase.Auth.auth.localid
	# connect both signals to data_updated instead,
	# if you don't want to deal with the parsing in new_data_udpate and patch_data_update
	db_ref.new_data_update.connect(new_data_updated)
	db_ref.patch_data_update.connect(patch_data_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func data_updated(data):
	player_status = db_ref.get_data()
	update_player_list()

func new_data_updated(data):
	print("new_data_updated")
	print(data)
	var path = data.key.split("/", true)
	if path.size() > 1:
		if data.data:
			# When a field is updated from the *console*, for example change the name of a player to Amy
			# {key:player_id/name, data:"Amy"}
			player_status[path[0]][path[1]] = data.data
		else:
			# When a field is deleted (not possible from this app, but possible on console), for example deleted the status field
			# {key:player_id/status, data:<null>}
			player_status[path[0]].erase(path[1])
	else:
		if data.data:
			# When first connected to the database
			# {key:player_id, data:{ "name": "Bob", "status": "Happy"}
			player_status[path[0]] = data.data
		else:
			# When a player is deleted (not possible from this app, but possible on console)
			# {key: player_id, data:<null>}
			player_status.erase(path[0])
			
	update_player_list()
	
func patch_data_updated(data):
	print("patch_data_updated")
	print(data)
	
	if data.key.is_empty():
		# When a new player is added to the player_status, the data.key will be empty. The actual "player_id" key will be in data.data:
		# example: {key:, data:{ "new_player_id": {"name":"Bob", "status": "Angry"}
		for key in data.data.keys():
			player_status[key] = data.data[key]
			
	else:
		var path = data.key.split("/", true)
		if path.size() > 1:
			# Seems that no case falls here, but we have this implemented anyway for good measure
			for key in data.data.keys():
				player_status[path[0]][path[1]][key] = data.data[key]
		else:
			# When a player updates a field (from this app), for example, Bob changed his status from Happy to Angry, the name stays the same
			# {key: player_id, data: {"status": "Angry"}
			# When a player updates a field (from this app), for example, Bob changed his status from Happy to Angry, the name from Bob to Amy
			# {key: player_id, data: {"name": "Amy", "status": "Angry"}
			if player_status.has(path[0]):
				for key in data.data.keys():
					player_status[path[0]][key] = data.data[key]
			else:
				player_status[path[0]] = data.data
			
	update_player_list()

func update_player_list():
	var list = "Players' status:\n"
	for key in player_status.keys():
		var cur_player_status = player_status[key]
		var name = "anonymous"
		if cur_player_status.has('name') and !cur_player_status.name.is_empty():
			name = cur_player_status.name
			if key == player_id and %NameLineEdit.text.is_empty():
				%NameLineEdit.text = name
			
		var status = "unknown"
		if cur_player_status.has('status') and !cur_player_status.status.is_empty():
			status = cur_player_status.status
			if key == player_id and %StatusLineEdit.text.is_empty():
				%StatusLineEdit.text = status
				
		list += name + " (" + status + ")\n"
		
	%PlayerListLabel.text = list

func _on_update_button_pressed():
	db_ref.update(player_id, {'name': %NameLineEdit.text, 'status': %StatusLineEdit.text})


func _on_logout_button_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://Authentication.tscn")
