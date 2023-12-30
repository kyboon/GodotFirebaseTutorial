extends Control

var petting_count: int = 0:
	set(value):
		petting_count = value
		%PettingCountLabel.text = str(value)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_panda_button_pressed():
	petting_count += 1
