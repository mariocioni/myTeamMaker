extends Node2D


export var MainAppScene : PackedScene	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Carica_team_button_up():
	$choice_sound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://Choose_load_format.tscn") # Replace with function body.


func _on_Creato_da_button_up():
	$choice_sound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://credits.tscn") # Replace with function body.


func _on_Nuovo_team_button_up():
	$choice_sound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://Pop_team.tscn") # Replace with function body.


func _on_Fake_team_button_up():
	var giocatori={"Aurelio":["d",3.5],"Chris":["c",2.5],"Darin":["c",1.25],"Donny":["c",0.5],"Dwayne":["d",2.25],"Evan":["a",0.25],"Foster":["c",1],"Grady":["c",0.25],"Hank":["d",3.5],"Jeremy":["a",2.5],"Jess":["d",1],"Jimmie":["c",1.75],"Joey":["d",1.75],"Kim":["a",3.5],"Mickey":["c",3.25],"Pasquale":["d",1.75],"Peter":["c",1.75],"Quinton":["c",0.5],"Romeo":["c",3.5],"Vern":["d",3]}
	GlobVars.giocatori=giocatori
	get_tree().change_scene("res://Pick_players.tscn") # Replace with function body.
