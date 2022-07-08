extends Node2D


onready var slotMachine = load("res://Scripts/SlotMachine.gd").new()
var rolled = false

var popedup = false
var popedup2 = false

onready var slot = $ViewportContainer/Viewport/SlotMachine
onready var lightAnim = $Luzes/AnimationPlayer


onready var buttonHoverSound = preload("res://sound/button/Button_Hover.mp3")



onready var buttonsAudio = $Audios/playBtnAudio
onready var optionsAudio = $Audios/optionsBtnAudio


onready var creditsLBL = $UIBaixo/Credits
onready var denomLBL = $UIBaixo/Denom
onready var levelLBL = $UIBaixo/Level
onready var betLBL = $UIBaixo/Bet
onready var moneybetLBL = $UIBaixo/MoneyBet

onready var winsMP3 = $Audios/Wins

onready var bigWinSound = preload("res://sound/wins sfx/Big_Win.mp3")
onready var goodWinSound = preload("res://sound/wins sfx/Good_Win.mp3")
onready var mediumWinSound = preload("res://sound/wins sfx/Medium_Win.mp3")
onready var smallWinSound = preload("res://sound/wins sfx/Small_Win.mp3")

var credits = 1000
var level = 1
var denom = 0.01
var bet = 25
onready var betValue = bet
var moneyBet = bet * denom


onready var winAnim = get_node("Win/AnimationPlayer")
onready var bigWinAnim = get_node("Win/bw/bigWinAnim")
onready var numerosBW = get_node("Win/bw/numeros bw")
onready var numeros = get_node("Win/numeros so")

var startPointsBW = false
var startPoints = false
var currentPoints = 0
var lastCred

var premioTocando

onready var playBtn = $play
onready var options2Btn = $options2
onready var replayBtn = $replay
onready var optionsBtns = $options


func _ready():
	slot.connect("stopped", self, "_on_slot_machine_stopped")
	lightAnim.play("luz")	

func _process(delta):
	var gudwin = get_node("ViewportContainer/Viewport/SlotMachine").goodWinToca
	var smolwin = get_node("ViewportContainer/Viewport/SlotMachine").smallWinToca
	var midiumwin = get_node("ViewportContainer/Viewport/SlotMachine").mediumWinToca
	var bigwin = get_node("ViewportContainer/Viewport/SlotMachine").bigWinToca
	var pointstGive = get_node("ViewportContainer/Viewport/SlotMachine").pointsToGive
	var actualPoints
	
	if gudwin == true:
		goodWin()
		get_node("ViewportContainer/Viewport/SlotMachine").goodWinToca = false
		
	if midiumwin == true:
		mediumWin()
		get_node("ViewportContainer/Viewport/SlotMachine").mediumWinToca = false
		
	if smolwin == true:
		smallWin()
		get_node("ViewportContainer/Viewport/SlotMachine").smallWinToca = false
		
	if bigwin == true:
		bigWin()
		get_node("ViewportContainer/Viewport/SlotMachine").bigWinToca = false
		print("Big win anim")
	
	if startPointsBW == true:
		actualPoints = pointstGive * bet
		if actualPoints > 50000:
			if actualPoints > currentPoints:
				currentPoints = int(currentPoints +15111 * delta)
				credits = int(credits +15111 * delta)
			else:
				currentPoints = actualPoints
				credits = lastCred+ actualPoints
		else:
			if actualPoints > currentPoints:
				currentPoints = int(currentPoints +2111 * delta)
				credits = int(credits +2111 * delta)
			else:
				currentPoints = actualPoints
				credits = lastCred+ actualPoints
	
	if startPoints == true:
		actualPoints = pointstGive * bet
		if actualPoints > 15000:
			if actualPoints > currentPoints:
				currentPoints = int(currentPoints +15111 * delta)
				credits = int(credits +15111 * delta)
			else:
				currentPoints = actualPoints
				credits = lastCred+ actualPoints
		else:
			if actualPoints > currentPoints:
				currentPoints = int(currentPoints +2500 * delta)
				credits = int(credits +2500 * delta)
			else:
				currentPoints = actualPoints
				credits = lastCred+ actualPoints
	
	
	bet = betValue * level
	moneyBet = bet * denom
	moneybetLBL.text = "$" + str(moneyBet)
	creditsLBL.text = str(credits)
	levelLBL.text = str(level)
	betLBL.text = str(bet)
	numerosBW.text = str(currentPoints)
	numeros.text = str(currentPoints)

func bigWin():
	slotMachine.premioTocando = true
	lastCred = credits
	currentPoints = 0
	bigWinAnim.play("bigwin24")
	lightAnim.play("luzbigwin")
	winsMP3.stream = bigWinSound
	startPointsBW = true
	if !winsMP3.is_playing():
		winsMP3.play()
		yield(get_tree().create_timer(winsMP3.stream.get_length()), "timeout")
		winsMP3.stop()
		premioTocando = false
		lightAnim.play("luz")

func goodWin():
	premioTocando = true
	lastCred = credits
	currentPoints = 0
	winAnim.play("goodwin")
	lightAnim.play("luzwin")
	winsMP3.stream = goodWinSound
	startPoints = true
	if !winsMP3.is_playing():
		winsMP3.play()
		yield(get_tree().create_timer(winsMP3.stream.get_length()), "timeout")
		winsMP3.stop()
		premioTocando = false
		lightAnim.play("luz")

func mediumWin():
	premioTocando = true
	lastCred = credits
	currentPoints = 0
	winAnim.play("mediumwin")
	lightAnim.play("luzwin")
	winsMP3.stream = mediumWinSound
	startPoints = true
	if !winsMP3.is_playing():
		winsMP3.play()
		yield(get_tree().create_timer(winsMP3.stream.get_length()), "timeout")
		winsMP3.stop()
		premioTocando = false
		lightAnim.play("luz")

func smallWin():
	premioTocando = true
	lastCred = credits
	currentPoints = 0
	winAnim.play("smallwin")
	lightAnim.play("luzwin")
	winsMP3.stream = smallWinSound
	startPoints = true
	if !winsMP3.is_playing():
		winsMP3.play()
		yield(get_tree().create_timer(winsMP3.stream.get_length()), "timeout")
		winsMP3.stop()
		lightAnim.play("luz")
		premioTocando = false
		print(premioTocando)

func _on_Roll2_button_down():
	if bet <= credits && bet != 0:
		credits = credits - bet
		if rolled == false:
			slot.start()
			rolled = true
		else:
			slot.stop()

func _on_slot_machine_stopped():
	rolled = false


func _on_options_button_down():
	if popedup== false:
		$options/AnimationPlayer.play("popup1o")
		if popedup2 == true:
			$options/AnimationPlayer.play("popup2c")
			popedup2 = false
			popedup = false
		else:
			popedup = true
			popedup2 = false
	elif popedup == true:
		$options/AnimationPlayer.play("popup1c")
		popedup = false
		popedup2 = false

func _on_replay_button_down():
	if popedup2== false:
		$options/AnimationPlayer.play("popup2o")
		if popedup == true:
			$options/AnimationPlayer.play("popup1c")
			popedup2 = false
			popedup = false
		else:
			popedup2 = true
			popedup = false
	elif popedup2 == true:
		$options/AnimationPlayer.play("popup2c")
		popedup2 = false
		popedup = false

func _on_Level_Sub_Btn_button_down():
		if level > 0:
			level = level -1
		else:
			level = 0

func _on_Level_Plus_Btn_button_down():
		if level < 10:
			level = level + 1
		else:
			level = 10

func _on_Denom_Plus_Btn_button_down():
		if denom == 0.01:
			denom = 0.02
			denomLBL.text = "0,02"
		elif denom == 0.02:
			denom = 0.05
			denomLBL.text = "0,05"
		elif denom == 0.05:
			denom = 0.10
			denomLBL.text = "0,10"
		elif denom == 0.10:
			denom = 0.20
			denomLBL.text = "0,20"
		elif denom == 0.20:
			denom = 0.50
			denomLBL.text = "0,50"

func _on_Denom_Sub_Btn_button_down():
		if denom == 0.50:
			denom = 0.20
			denomLBL.text = "0,20"
		elif denom == 0.20:
			denom = 0.10
			denomLBL.text = "0,10"
		elif denom == 0.10:
			denom = 0.05
			denomLBL.text = "0,05"
		elif denom == 0.05:
			denom = 0.02
			denomLBL.text = "0,02"
		elif denom == 0.02:
			denom = 0.01
			denomLBL.text = "0,01"

func _pointsToGive(points):
	credits = credits + points

func _on_play_mouse_entered():
	buttonsAudio.stream = buttonHoverSound
	buttonsAudio.play()
	yield(get_tree().create_timer(buttonsAudio.stream.get_length()), "timeout")
	buttonsAudio.stop()

func _on_replay_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop() 

func _on_options2_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_fast_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_historico_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_money_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_info_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_10_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_25_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_50_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_100_mouse_entered():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_info_button_down():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	get_tree().change_scene("res://scenes/aboutthegame.tscn")

func _on_historico_button_down():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	get_tree().change_scene("res://scenes/playhistory.tscn")

func _on_money_button_down():
	optionsAudio.stream = buttonHoverSound
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	get_tree().change_scene("res://scenes/symbolspayout.tscn")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_B:
			yield(get_tree().create_timer(0.5), "timeout")
			playBtn.visible = false
			options2Btn.visible = false
			replayBtn.visible = false
			optionsBtns.visible = false
