extends Control

func _ready():
	$VBoxContainer/CSV_Container/LineEdit.grab_focus() # Replace with function body.

func load_json(path):
	var file=File.new()
	if not file.file_exists(path):
		return
	file.open(path,file.READ)
	var text=file.get_as_text()
	var giocatori=parse_json(text)
	return(giocatori)

func _on_JSON_Button_button_up():
	$VBoxContainer/JSON_Container2/FileDialog.popup()
	
	

func load_csv(path):
	var giocatori={}
	var file = File.new()
	if not file.file_exists(path):
		return
	file.open(path,file.READ)
	while !file.eof_reached():
		var csv=file.get_csv_line()
		if csv.size()>1: 
			giocatori[csv[0]]=[csv[1],float(csv[2])]
	file.close()		
	return(giocatori)


func _on_CSV_Button_button_up():
	$VBoxContainer/CSV_Container/FileDialog_CSV.popup()
#	var path = "user://"+$VBoxContainer/CSV_Container/LineEdit.text
#	var giocatori=load_csv(path)
#	notify_write_data(giocatori)
#	var saveName="user://"+"JSON"+$VBoxContainer/CSV_Container/LineEdit.text
#	saveData(saveName)
	
func notify_write_data(giocatori):
	if len(giocatori)>0:
		$VBoxContainer/HBoxContainer/Instructions/Notice.text='Caricati con successo i dati di '+String(len(giocatori))+ ' giocatori'
		$VBoxContainer/HBoxContainer/goplay_Button.disabled=false
		GlobVars.giocatori=giocatori
	if len(giocatori)==0:
		$VBoxContainer/HBoxContainer/Instructions/Notice.text='Non ho caricato punti giocatori: problema col file?'
		


func _on_goplay_Button_button_up():
	get_tree().change_scene("res://Pick_players.tscn") # Replace with function body.

func saveData(filename) -> void:
	var saveFile = File.new()
	saveFile.open(filename, File.WRITE)
	saveFile.store_line(to_json(GlobVars.giocatori))
	saveFile.close()


func _on_goback_Button_button_up():
	get_tree().change_scene("res://Menu_iniziale.tscn") # Replace with function body.


func _on_FileDialog_file_selected(path):
	var giocatori={}
	giocatori=load_json(path)
	notify_write_data(giocatori) # Replace with function body.


func _on_FileDialog_CSV_file_selected(path):
	var giocatori={}
	giocatori=load_csv(path)
	notify_write_data(giocatori) # Replace with # Replace with function body.
