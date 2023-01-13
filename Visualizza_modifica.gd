extends Node2D

var sq=GlobVars.scelta.duplicate() #per creare copia distinta
var chiari=sq[0].duplicate()
var scuri=sq[1].duplicate()


func _ready():
	alloca_team()
	scrivi_forza()

func alloca_team():
	clear_containers()
	var list_chiari=chiari.keys()
	list_chiari.sort()	
	var list_scuri=scuri.keys()
	list_scuri.sort()
	for p in list_chiari:
		var button = Button.new()
		button.text = String(p)
		if chiari[p][0]=='d':
			$dif_chiari.add_child(button)	
		if chiari[p][0]=='a':
			$att_chiari.add_child(button)	
		else:
			$lista_chiari.add_child(button)	
		button.connect("pressed", self, "_button_pressed",[button])
	for p in list_scuri:
		var button = Button.new()
		button.text = String(p)
		if scuri[p][0]=='d':
			$dif_scuri.add_child(button)	
		if scuri[p][0]=='a':
			$att_scuri.add_child(button)	
		else:
			$lista_scuri.add_child(button)	
		button.connect("pressed", self, "_button_pressed",[button])
		
func clear_containers():
	var cosa=[$lista_chiari,$att_chiari,$dif_chiari,$lista_scuri,$att_scuri,$dif_scuri]
	for x in cosa:
		for n in x.get_children():
			x.remove_child(n)
			n.queue_free()

	
func scrivi_forza():
	var forza_c=0
	for p in chiari:
		forza_c+=chiari[p][1]
	var roles_chiari=count_roles(chiari)
	$forza_chiari.text=	"Forza: %s" % forza_c	
	$forza_chiari.text+= "\n"+ "Numero: %s" % len(chiari)
	var forza_s=0
	for p in scuri:
		forza_s+=scuri[p][1]
	var roles_scuri=count_roles(scuri)
	$forza_scuri.text=	"Forza: %s" % forza_s	
	$forza_scuri.text+= "\n"+ "Numero: %s" % len(scuri)

	
func _button_pressed(button: Button):
	$sposta.play()
	var nome=button.text
	change_side(nome)
	alloca_team()
	scrivi_forza()

func change_side(nome): #moves player nome to other side
	if nome in chiari:
		scuri[nome]=chiari[nome]
		chiari.erase(nome)
	else:
		chiari[nome]=scuri[nome]
		scuri.erase(nome)			

func count_roles(team):#nome della squadra in ingresso, restituisce booleano
	var dif = 0
	var cen = 0
	var att = 0
	for x in team.values():
		if x[0] == 'd':
			dif+=1
		if x[0] == 'c':
			cen+=1
		if x[0] == 'a':
			att+=1
	return [dif, cen, att]


func _on_reset_button_pressed():
	chiari=GlobVars.scelta[0].duplicate()
	scuri=GlobVars.scelta[1] .duplicate()
	alloca_team()
	scrivi_forza()


func _on_back_button_up():
	get_tree().change_scene("res://Menu_iniziale.tscn")
