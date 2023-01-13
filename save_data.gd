extends Node2D

var nameFile

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ok_Button_button_up():
	nameFile="user://"+$VBoxContainer/CenterContainer/LineEdit.text
	print(nameFile)
	saveData()

func saveData() -> void:
	var saveFile = File.new()
	saveFile.open(nameFile, File.WRITE)
	saveFile.store_line(to_json(GlobVars.giocatori))
	saveFile.close()


func _on_goback_button_up():
	get_tree().change_scene("res://Pick_players.tscn") 
