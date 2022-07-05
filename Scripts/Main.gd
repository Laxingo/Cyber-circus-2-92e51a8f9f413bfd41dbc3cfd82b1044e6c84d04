extends Node2D

onready var slot = $ViewportContainer/Viewport/SlotMachine
onready var lightAnim = $Luzes/AnimationPlayer
onready var slotMachine = load("res://Scripts/SlotMachine.gd").new()
var rolled = false

var popedup = false
var popedup2 = false

onready var carpet1 = preload("res://sound/music/Cyber Circus Carpet Asharp.mp3")
onready var carpet2 = preload("res://sound/music/Cyber Circus Carpet Dsharp.mp3")
onready var playBtn = preload("res://sound/button/Cyber Circus Button Hover-001.mp3")
onready var reelSound = preload("res://sound/reels spin/Cyber Circus Reel Just Spin.mp3")


var carpet1played
onready var jukebox = $Jukebox
onready var playAudio = $playBtnAudio
onready var optionsAudio = $optionsBtnAudio
onready var options2Audio = $options2BtnAudio

onready var reel1 = $reel1
onready var reel2 = $reel1
onready var reel3 = $reel1
onready var reel4 = $reel1
onready var reel5 = $reel1

var credits = 1000
var level = 1
var denom = 0.01
var bet = 25
onready var betValue = bet
var moneyBet = bet * denom
onready var creditsLBL = $UIBaixo/Credits
onready var denomLBL = $UIBaixo/Denom
onready var levelLBL = $UIBaixo/Level
onready var betLBL = $UIBaixo/Bet
onready var moneybetLBL = $UIBaixo/MoneyBet

func _ready():
	slot.connect("stopped", self, "_on_slot_machine_stopped")
	lightAnim.play("luz")
	jukebox.stream = carpet1

func startReelSound(numberR):
	if numberR == 1:
		if !reel1.is_playing():
			reel1.stream = reelSound
			reel1.play()
	if numberR == 2:
		if !reel2.is_playing():
			reel2.stream = reelSound
			reel2.play()
	if numberR == 3:
		if !reel3.is_playing():
			reel3.stream = reelSound
			reel3.play()
	if numberR == 4:
		if !reel4.is_playing():
			reel4.stream = reelSound
			reel4.play()
	if numberR == 5:
		if !reel5.is_playing():
			reel5.stream = reelSound
			reel5.play()

func _process(delta):
#	_jukebox()
	if get_node("ViewportContainer/Viewport/SlotMachine").doit1 == true:
		startReelSound(1)
		get_node("ViewportContainer/Viewport/SlotMachine").doit1 = false
	if get_node("ViewportContainer/Viewport/SlotMachine").doit2 == true:
		startReelSound(2)
		get_node("ViewportContainer/Viewport/SlotMachine").doit2 = false
	if get_node("ViewportContainer/Viewport/SlotMachine").doit3 == true:
		startReelSound(3)
		get_node("ViewportContainer/Viewport/SlotMachine").doit3 = false
	if get_node("ViewportContainer/Viewport/SlotMachine").doit4 == true:
		startReelSound(4)
		get_node("ViewportContainer/Viewport/SlotMachine").doit4 = false
	if get_node("ViewportContainer/Viewport/SlotMachine").doit5 == true:
		startReelSound(5)
		get_node("ViewportContainer/Viewport/SlotMachine").doit5 = false
		
		
		
	bet = betValue * level
	moneyBet = bet * denom
	moneybetLBL.text = "$" + str(moneyBet)
	creditsLBL.text = str(credits)
	levelLBL.text = str(level)
	betLBL.text = str(bet)

func _jukebox():
	if !jukebox.is_playing():
		jukebox.stream = carpet1
		jukebox.play()
		yield(get_tree().create_timer(jukebox.stream.get_length()), "timeout")
		jukebox.stream = carpet2
		jukebox.play()
		yield(get_tree().create_timer(jukebox.stream.get_length()), "timeout")
		jukebox.stop()

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

func _on_info_button_down():
	options2Audio.stream = playBtn
	options2Audio.play()
	yield(get_tree().create_timer(options2Audio.stream.get_length()), "timeout")
	get_tree().change_scene("res://scenes/aboutthegame.tscn")


func _on_historico_button_down():
	options2Audio.stream = playBtn
	options2Audio.play()
	yield(get_tree().create_timer(options2Audio.stream.get_length()), "timeout")
	get_tree().change_scene("res://scenes/playhistory.tscn")


func _on_money_button_down():
	options2Audio.stream = playBtn
	options2Audio.play()
	yield(get_tree().create_timer(options2Audio.stream.get_length()), "timeout")
	get_tree().change_scene("res://scenes/symbolspayout.tscn")
	

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
	pass


func _on_reel1_finished():
	 pass # Replace with function body.

func _on_play_mouse_entered():
	playAudio.stream = playBtn
	playAudio.play()
	yield(get_tree().create_timer(playAudio.stream.get_length()), "timeout")
	playAudio.stop()

func _on_replay_mouse_entered():
	options2Audio.stream = playBtn
	options2Audio.play()
	yield(get_tree().create_timer(options2Audio.stream.get_length()), "timeout")
	options2Audio.stop() 

func _on_options2_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()

func _on_fast_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()


func _on_historico_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()


func _on_money_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()


func _on_info_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()


func _on_10_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()


func _on_25_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()


func _on_50_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()


func _on_100_mouse_entered():
	optionsAudio.stream = playBtn
	optionsAudio.play()
	yield(get_tree().create_timer(optionsAudio.stream.get_length()), "timeout")
	optionsAudio.stop()
