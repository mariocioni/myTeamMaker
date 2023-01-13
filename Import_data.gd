extends Node2D


var giocatori:Dictionary
var presenti:Dictionary
var selected_players = []
# Called when the node enters the scene tree for the first time.
func _ready():
	if len(GlobVars.giocatori)==0:
		load_csv()
	else:
		giocatori=GlobVars.giocatori	
	pop_lista()


func load_csv():
	var file = File.new()
	file.open("res://data/giocatori.dat",file.READ)
	while !file.eof_reached():
		var csv=file.get_csv_line()
		if csv.size()>1: 
			giocatori[csv[0]]=[csv[1],float(csv[2])]
	file.close()
	

func pop_lista():
#	for k in giocatori.keys():
#		get_node("MarginContainer/Container/ItemList").add_item(k)
	var players = giocatori.keys()
	var players_box = GridContainer.new()
	players_box.columns=2
#	players_box.
	$MarginContainer/Container/VBox.add_child(players_box)
#	$MarginContainer/Container.move_child(players_box,1)
	for item in players:
		var check_button = CheckButton.new()
		check_button.text = item
		players_box.add_child(check_button)
		check_button.connect("toggled", self, "_on_item_toggled", [item])
	players_box.PRESET_CENTER
	
func _on_item_toggled(item, value):
	if item:
		selected_players.append(value)
		print(value)
	else:
		selected_players.erase(value)
	print("Selected players:", selected_players)

	
	
func _on_Bottone_vai_pressed():
	$vai.play()
	yield(get_tree().create_timer(0.5), "timeout")
	crea_dic_presenti()
	GlobVars.presenti=presenti
	get_tree().change_scene("res://Propose_teams.tscn")
	
func stampa_presenti(pres):
	print('PRESENTI:')
	print(' '.join(pres.keys()))
	print('-----------------')	

func crea_dic_presenti(): 
#	var sel = get_node("MarginContainer/Container/ItemList").get_selected_items()
	for p in selected_players:
#		var nome=giocatori.keys()[p]
		presenti[p]=giocatori[p]
	#print(JSON.print(presenti, "\t"))



