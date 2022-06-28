extends Node2D

onready var slot = $ViewportContainer/Viewport/SlotMachine
onready var lightAnim = $Luzes/AnimationPlayer
var rolled = false

var popedup = false
var popedup2 = false

onready var carpet1 = preload("res://sound/music/Cyber Circus Carpet Asharp.mp3")
onready var carpet2 = preload("res://sound/music/Cyber Circus Carpet Dsharp.mp3")
onready var playBtn = preload("res://sound/button/Cyber Circus Button Hover-001.mp3")


var carpet1played
onready var jukebox = $Jukebox
onready var playAudio = $playBtnAudio
onready var optionsAudio = $optionsBtnAudio
onready var options2Audio = $options2BtnAudio



var credits = 100
var level = 1
var denom = 0
var bet = denom * level

onready var creditsLBL = $Credits
onready var denomLBL = $Denom
onready var levelLBL = $Level
onready var betLBL = $Bet

func _ready():
	slot.connect("stopped", self, "_on_slot_machine_stopped")
	lightAnim.play("luz")
	jukebox.stream = carpet1

func _process(delta):
	_jukebox()
	bet = denom * level
	creditsLBL.text = str(credits)
	denomLBL.text = str(denom)
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
#	if bet < credits:
		if level < 3:
			level = level + 1
#			if bet > credits:
#				level = level - 1
		else:
			level = 3


func _on_Denom_Plus_Btn_button_down():
#	if bet < credits:
		if denom <= 9.9:
			denom = denom + 0.10
#			if bet > credits:
#				denom = denom - 0.10
		else:
			denom = 10

		


func _on_Denom_Sub_Btn_button_down():
	if denom > 0.10:
		denom = denom - 0.10

	else:
		denom = 0.10
