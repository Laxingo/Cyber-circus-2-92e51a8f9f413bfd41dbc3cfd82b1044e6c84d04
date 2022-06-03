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

onready var reelSound1 = preload("res://sound/reels spin/Cyber Circus Reel Just Spin.mp3")
onready var reelSound2 = preload("res://sound/reels spin/Cyber Circus Reel Reel Set.mp3")

onready var reel1Audio = $reel1
onready var reel2Audio = $reel2
onready var reel3Audio = $reel3
onready var reel4Audio = $reel4
onready var reel5Audio = $reel5


func _ready():
	slot.connect("stopped", self, "_on_slot_machine_stopped")
	lightAnim.play("luz")
	jukebox.stream = carpet1

func _process(delta):
	_jukebox()
	pass

func _jukebox():
	if !jukebox.is_playing():
		jukebox.stream = carpet1
		jukebox.play()
		yield(get_tree().create_timer(jukebox.stream.get_length()), "timeout")
		jukebox.stream = carpet2
		jukebox.play()
		yield(get_tree().create_timer(jukebox.stream.get_length()), "timeout")
		jukebox.stop()

func _reelAudio(_reelnumber):
	if _reelnumber == 0:
		reel1Audio.stream = reelSound1
		reel1Audio.play()
	elif _reelnumber == 1:
		reel2Audio.stream = reelSound1
		reel2Audio.play()
	elif _reelnumber == 2:
		reel3Audio.stream = reelSound1
		reel3Audio.play()
	elif _reelnumber == 3:
		reel4Audio.stream = reelSound1
		reel4Audio.play()
	elif _reelnumber == 4:
		reel5Audio.stream = reelSound1
		reel5Audio.play()

func _on_Roll2_button_down():
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
