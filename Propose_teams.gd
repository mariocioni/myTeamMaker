extends Control


var presenti = GlobVars.presenti
var min_d
var min_c
var min_a
var tol=0.25
var i=0
var found = 0
var first_shown = false

func _ready():
	vincoli_ruoli(presenti)
	stampa_presenti(presenti)

func vincoli_ruoli(people):
	var dif = 0
	var cen = 0
	var att = 0
	for x in people.values():
		if x[0] == 'd':
			dif+=1
		if x[0] == 'c':
			cen+=1
		if x[0] == 'a':
			att+=1
	min_d=int(dif/2)
	min_c=int(cen/2)
	min_a=int(att/2)

func stampa_presenti(people):
	$Sfondo/Presenti.text='Presenti:'+String(len(people))+'\n'+'\n'
	var lista_presenti=people.keys()
	lista_presenti.sort()
	for p in lista_presenti:
		$Sfondo/Presenti.text+=String(p)+'\n'

func _on_Stampa_Presenti_pressed():
	stampa_presenti(presenti)

func _on_Genera_pressed():
	var candidate
	print("Provo a generare le squadre")
	candidate=crea_squadre(presenti)
	var n=int(len(candidate)/2)
	print('Proposte possibili '+String(n))
	if found==0:
		$Sfondo/Avvisi.text="Nessuna soluzione trovata con tol = "+String(tol-0.25)+'\n'
		$Sfondo/Avvisi.text+="Premere Genera squadre per riprovare con tol = "+String(tol)
		
		print("Nessuna soluzione")
		tol+=0.25
	else:
		$Sfondo/Avvisi.text='Ci sono '+ String(found)+' possibilità: premere Next per vederle in sequenza '
		GlobVars.candidate = candidate
		$Sfondo/Genera.disabled=true
		$Sfondo/Next.disabled=false
		$Sfondo/Scelta_random.disabled=false		

func crea_squadre(pres):
	$Sfondo/Squadre.text=''
	var n = len(pres)
	var proposte=[]
	for perm in combinations(pres.keys(),int(n/2)): 
		var chiari = {}
		var scuri = {}
		for k in pres.keys():
			if k in perm:
				chiari[k]=pres[k]
			else: 
				scuri[k]=pres[k]	
		if valuta_squadre(chiari,scuri):
			found += 1
			proposte.append([chiari,scuri])
	return proposte

func valuta_squadre(chiari,scuri): #True se ok altrimenti False
	var diff_forza=abs(get_team_strength(chiari)-get_team_strength(scuri))
	var crit_forza=(diff_forza<tol)
	if not crit_forza:
		return false
	var crit_bilanciamento=(bilanciamento(chiari,min_d,min_c,min_a) and bilanciamento(scuri,min_d,min_c,min_a))
	return (crit_forza and crit_bilanciamento)

func get_team_strength(d):
	var res=0
	for p in d.values():
		res+=p[1]
	return res

func combinations(iterable, r):
	var pool = iterable.duplicate()
	var n = len(pool)
	if r > n:
		return
	var res=[]
	var indices = []
	for l in range(r):
		indices.append(l)
	var parz=[]
	for i in indices:
		parz.append(pool[i])
	res.append(parz)
	while true:
		var chk=true
		var t
		for i in range(r-1,-1,-1):
			if indices[i] != i + n - r:
				t=i
				chk=false
				break
		if chk:
			return res
		indices[t] += 1
		for j in range(t+1, r):
			indices[j] = indices[j-1] + 1
		parz=[]
		for k in indices:
			parz.append(pool[k])
		res.append(parz)

func bilanciamento(team,min_d,min_c,min_a):#nome della squadra in ingresso, restituisce booleano
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
	return ((dif>=min_d) and (cen>=min_c) and (att>=min_a))

func _on_Next_pressed():
	if found==0:
		return
	if !first_shown:
		first_shown=true
		if $Sfondo/Scelta.disabled:
			$Sfondo/Scelta.disabled=false	
	if i>=(found):#per ciclare sulle proposte effettivamente diverse
		i=0
	print('Proposta '+String(i))
	var sq=GlobVars.candidate[i]
	var chiari=sq[0]
	var scuri=sq[1]
	print_teams(chiari,scuri)
	var forza_c=get_team_strength(chiari)
	var forza_s=get_team_strength(scuri)
	print('forza chiari = ',forza_c,' forza scuri = ', forza_s)
	i+=1

func stampa_squadre(team):
	var lista_presenti=team.keys()
	lista_presenti.sort()
	for p in lista_presenti:
		$Sfondo/Squadre.text+=String(p)+'\n'		
		
func print_teams(t1,t2):
	$Sfondo/Avvisi.text='Soluzione '+String(i+1)+' di '+ String(found) +' con dif >= '+String(min_d) + ' cen >= ' +String(min_c) + ' att >= '+String(min_a) + ' diff_forza = '+String(tol-0.25) + '\n'
	$Sfondo/Squadre.text='CHIARI'+'\n'
	stampa_squadre(t1)
	$Sfondo/Squadre.text+='\n'+'\n'+'SCURI'+'\n'
	stampa_squadre(t2) 


func _on_Cambia_Presenti_pressed():
	get_tree().change_scene("res://Pick_players.tscn") # Replace with function body.

func _on_Scelta_pressed():
	if found==0:
		return
	GlobVars.scelta = GlobVars.candidate[i-1]
	get_tree().change_scene("res://Vedi_sposta.tscn")


func _on_Scelta_random_button_up():
	randomize()
	var num =randi()%found
	GlobVars.scelta = GlobVars.candidate[num] # Replace with function body.
	get_tree().change_scene("res://Vedi_sposta.tscn")
