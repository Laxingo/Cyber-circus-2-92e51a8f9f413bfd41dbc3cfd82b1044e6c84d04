extends Node2D


onready var animP = $AnimationPlayer
onready var tweenie = $Tween
onready var roda = $Roda
onready var facaAnim = $faca/AnimationPlayer
onready var facaAnim2 = $faca2/AnimationPlayer
onready var facaAnim3 = $faca3/AnimationPlayer
onready var faca = $faca
onready var faca2 = $faca2
onready var faca3 = $faca3
onready var facaSprite = $faca/KnifeSpritesheet
onready var facaSprite2 = $faca2/KnifeSpritesheet
onready var facaSprite3 = $faca3/KnifeSpritesheet
onready var facaHitbox = $FacaHitbox
onready var hitboxes = $Roda/Hitboxes
onready var winazulLBL = $winazul
onready var glow = $faca/KnifeGlow
onready var glow2 = $faca2/KnifeGlow
onready var glow3 = $faca3/KnifeGlow
onready var palhacoAnim = $amiguinhos/Clown/AnimationPlayer
onready var coelhoAnim = $amiguinhos/Bunny/AnimationPlayer
onready var click1 = $faca/click
onready var click2 = $faca2/click
onready var click3 = $faca3/click


var facaPos = Vector2(639, 169)

var prontaprarodar = false
var prontopraclicar = false

onready var random = RandomNumberGenerator.new()


onready var knifeSound = preload("res://sound/bonus/Bonus_KnifeThrow.mp3")
onready var knifeMissSound = preload("res://sound/bonus/Bonus_KnifeThrow_withoutImpact.mp3")
onready var music = preload("res://sound/bonus/Bonus_Music.mp3")
onready var transition1 = preload("res://sound/bonus/Bonus_Transition_In.mp3")
onready var transition2 = preload("res://sound/bonus/Bonus_Transition_Out.mp3")
onready var winSound = preload("res://sound/bonus/Bonus_Win.mp3")

onready var jukebox = $Jukebox
onready var musicAudio = preload("res://sound/music/Ambience.mp3")

onready  var knifeMP3 = $KnifeSoundMP3
onready  var knifeMissMP3 = $KnifeMiss

onready var musicMp3 = $MusicMP3
onready var transitionMP3 = $TransMP3
onready var winMP3 = $WinMP3
onready var knivesLabel = $CyberCircusArenaBonus/Label

onready var knives = 3

var playsound = false
var amiguinhos = false

var faca1Thrown = false
var faca2Thrown = false
var faca3Thrown = false

func _ready():
	_jukebox()
	pass

func bonusSound():
	if !musicMp3.is_playing():
		musicMp3.play()

var comecou = false

var faca1desaparece = false
var faca2desaparece = false
var faca3desaparece = false


func _process(delta):
	knivesLabel.text = str("x", knives)
	if playsound:
		bonusSound()
	else:
		musicMp3.stop()
	if prontaprarodar:
		roda.rotation_degrees = roda.rotation_degrees + 250 * delta
	else:
		roda.rotation_degrees = roda.rotation_degrees
	
	if amiguinhos == true:
		if !comecou:
			comecou = true
			amiguinhPalhaco()
			amiguinhoCoelho()
	if faca1desaparece && faca.modulate.a != 0:
		faca.modulate.a = faca.modulate.a -0.01
	if faca2desaparece && faca2.modulate.a != 0:
		faca2.modulate.a = faca2.modulate.a -0.01
	if faca3desaparece && faca3.modulate.a != 0:
		faca3.modulate.a = faca3.modulate.a -0.01

func bonusTocando(yesorNo):
	return
func _entra():
	click1.visible = true
	click2.visible = true
	click3.visible = true
	knives = 3
	bonusTocando = true
	cortinaSound()
	self.visible = true
	animP.play("1bonusentrada")
	yield(get_tree().create_timer(animP.get_animation("1bonusentrada").length + 0.2), "timeout")
	animP.play("2throwtheknife")
	yield(get_tree().create_timer(animP.get_animation("2throwtheknife").length +0.5), "timeout")
	animP.play("tudobaza")
	transitionMP3.stream = transition2
	cortinaSound()
	amiguinhos = true
	yield(get_tree().create_timer(animP.get_animation("tudobaza").length), "timeout")
	animP.play("3rodaluzentra")
	yield(get_tree().create_timer(animP.get_animation("tudobaza").length), "timeout")
	animP.play("4rodaroda")
	yield(get_tree().create_timer(2), "timeout")
	prontaprarodar = true
	yield(get_tree().create_timer(2), "timeout")
	facaAnim.play("facaentra")
	yield(get_tree().create_timer(1), "timeout")
	facaAnim.play("click")
	prontopraclicar = true
	yield(get_tree().create_timer(facaAnim.get_animation("click").length), "timeout")
	if prontopraclicar:
		facaAnim.play("facaglow")

onready var random2 = RandomNumberGenerator.new()

func amiguinhoCoelho():
	random2.randomize()
	var num = random2.randi_range(5, 15)
	yield(get_tree().create_timer(num), "timeout")
	coelhoAnim.play("bunnymaroto")
	yield(get_tree().create_timer(coelhoAnim.get_animation("bunnymaroto").length), "timeout")
	comecou = false

func amiguinhPalhaco():
	random2.randomize()
	var num2 = random2.randi_range(5, 15)
	yield(get_tree().create_timer(num2), "timeout")
	palhacoAnim.play("palhacocurioso")
	yield(get_tree().create_timer(palhacoAnim.get_animation("palhacocurioso").length), "timeout")
	comecou = false

var bonusTocando = false

func _on_RodaBtn_pressed():
	glow.visible = false
	random.randomize()
	var num = random.randi_range(0, 7)
	if prontopraclicar:
		prontopraclicar = false
		if!faca1Thrown:
			click1.visible = false
			knives = 2
			faca1Thrown = true
			if num == 0:
				facaAnim.play("1faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				_WinAmarelo()
			elif num == 1:
				facaAnim.play("2faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				facaHitbox.position = facaSprite.position
				yield(get_tree().create_timer(0.6), "timeout")
				facaHitbox.position = facaPos
			elif num == 2:
				facaAnim.play("3faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				facaHitbox.position = facaSprite.position 
				yield(get_tree().create_timer(0.6), "timeout")
				facaHitbox.position = facaPos
			elif num == 3:
				facaAnim.play("facaf1")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca1desaparece = true
				yield(get_tree().create_timer(0.6), "timeout")
				facaAnim2.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim2.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim2.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim2.play("facaglow")
			elif num == 4:
				facaAnim.play("facaf2")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca1desaparece = true
				yield(get_tree().create_timer(0.6), "timeout")
				facaAnim2.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim2.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim2.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim2.play("facaglow")
			elif num == 5:
				facaAnim.play("facaf3")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca1desaparece = true
				yield(get_tree().create_timer(0.8), "timeout")
				facaAnim2.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim2.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim2.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim2.play("facaglow")
			elif num == 6:
				facaAnim.play("facaf4")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca1desaparece = true
				yield(get_tree().create_timer(0.6), "timeout")
				facaAnim2.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim2.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim2.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim2.play("facaglow")
			elif num == 7:
				facaAnim.play("facaf5")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca1desaparece = true
				yield(get_tree().create_timer(0.6), "timeout")
				facaAnim2.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim2.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim2.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim2.play("facaglow")
				
		elif!faca2Thrown:
			click2.visible = false
			knives = 1
			faca2Thrown = true
			glow2.visible = false
			if num == 0:
				facaAnim2.play("1faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				_WinAmarelo()
			elif num == 1:
				facaAnim2.play("2faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				facaHitbox.position = facaSprite2.position
				yield(get_tree().create_timer(0.6), "timeout")
				facaHitbox.position = facaPos
			elif num == 2:
				facaAnim2.play("3faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				facaHitbox.position = facaSprite2.position 
				yield(get_tree().create_timer(0.6), "timeout")
				facaHitbox.position = facaPos
			elif num == 3:
				facaAnim2.play("facaf1")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca2desaparece = true
				yield(get_tree().create_timer(0.6), "timeout")
				facaAnim3.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim3.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim3.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim3.play("facaglow")
			elif num == 4:
				facaAnim2.play("facaf2")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca2desaparece = true
				yield(get_tree().create_timer(0.6), "timeout")
				facaAnim3.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim3.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim3.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim3.play("facaglow")
			elif num == 5:
				facaAnim2.play("facaf3")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca2desaparece = true
				yield(get_tree().create_timer(0.8), "timeout")
				facaAnim3.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim3.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim3.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim3.play("facaglow")
			elif num == 6:
				facaAnim2.play("facaf4")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca2desaparece = true
				yield(get_tree().create_timer(0.6), "timeout")
				facaAnim3.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim3.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim3.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim3.play("facaglow")
			elif num == 7:
				facaAnim2.play("facaf5")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca2desaparece = true
				yield(get_tree().create_timer(0.6), "timeout")
				facaAnim3.play("facaentra")
				animP.play("4rodaroda")
				yield(get_tree().create_timer(0.7), "timeout")
				prontaprarodar = true
				yield(get_tree().create_timer(1), "timeout")
				facaAnim3.play("click")
				prontopraclicar = true
				yield(get_tree().create_timer(facaAnim3.get_animation("click").length), "timeout")
				if prontopraclicar:
					facaAnim3.play("facaglow")
		else:
			click3.visible = false
			knives = 0
			faca3Thrown = true
			glow3.visible = false
			if num == 0:
				facaAnim3.play("1faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				_WinAmarelo()
			elif num == 1:
				facaAnim3.play("2faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				facaHitbox.position = facaSprite3.position
				yield(get_tree().create_timer(0.6), "timeout")
				facaHitbox.position = facaPos
			elif num == 2:
				facaAnim3.play("3faca")
				atiraFacaSOM()
				yield(get_tree().create_timer(0.6), "timeout")
				prontaprarodar = false
				facaHitbox.position = facaSprite3.position 
				yield(get_tree().create_timer(0.6), "timeout")
				facaHitbox.position = facaPos
			elif num == 3:
				facaAnim3.play("facaf1")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca3desaparece = true
				amiguinhos= false
				yield(get_tree().create_timer(2), "timeout")
				animP.play("cortinasentrada")
				yield(get_tree().create_timer(1), "timeout")
				animP.play("tudobaza2")
				bonusTocando = false
				playsound = false
				
				_jukebox()
				
			elif num == 4:
				facaAnim3.play("facaf2")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca3desaparece = true
				amiguinhos= false
				animP.play("cortinasentrada")
				yield(get_tree().create_timer(1), "timeout")
				animP.play("tudobaza2")
				bonusTocando = false
				playsound = false
				_jukebox()
				
			elif num == 5:
				facaAnim3.play("facaf3")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca3desaparece = true
				amiguinhos= false
				animP.play("cortinasentrada")
				yield(get_tree().create_timer(1), "timeout")
				animP.play("tudobaza2")
				bonusTocando = false
				playsound = false
				_jukebox()
				
			elif num == 6:
				facaAnim3.play("facaf4")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca3desaparece = true
				amiguinhos= false
				animP.play("cortinasentrada")
				yield(get_tree().create_timer(1), "timeout")
				animP.play("tudobaza2")
				bonusTocando = false
				playsound = false
				_jukebox()
				
			elif num == 7:
				facaAnim3.play("facaf5")
				atiraFacaMissSOM()
				yield(get_tree().create_timer(0.5), "timeout")
				faca3desaparece = true
				amiguinhos= false
				animP.play("cortinasentrada")
				yield(get_tree().create_timer(1), "timeout")
				animP.play("tudobaza2")
				bonusTocando = false
				playsound = false
				_jukebox()

func atiraFacaSOM():
	knifeMP3.play()
	yield(get_tree().create_timer(knifeMP3.stream.get_length()), "timeout")
	knifeMP3.stop()

func atiraFacaMissSOM():
	knifeMissMP3.play()
	yield(get_tree().create_timer(knifeMissMP3.stream.get_length()), "timeout")
	knifeMissMP3.stop()

func cortinaSound():
	transitionMP3.play()
	jukebox.stop()
	yield(get_tree().create_timer(transitionMP3.stream.get_length()), "timeout")
	transitionMP3.stop()
	playsound = true
	transitionMP3.stream = transition1
	

func _on_Rosa1_area_entered(area):
	_WinRosa()

func _on_Rosa_2_area_entered(area):
	_WinRosa()

func _on_Rosa_3_area_entered(area):
	_WinRosa()

func _on_Rosa_4_area_entered(area):
	_WinRosa()


func _on_Amarelo_1_area_entered(area):
	_WinAzul()

func _on_Amarelo_2_area_entered(area):
	_WinAzul()

func _on_Amarelo_3_area_entered(area):
	_WinAzul2()

func _on_Amarelo_4_area_entered(area):
	_WinAzul2()

onready var creditsToGive



func _WinRosa():
	playsound = false
	musicMp3.stop()
	winSoundFunc()
	animP.play("winrosa")
	amiguinhos = false
	yield(get_tree().create_timer(animP.get_animation("winrosa").length), "timeout")
	animP.play("winrosabaza")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("cortinasentrada")
	yield(get_tree().create_timer(1), "timeout")
	animP.play("tudobaza2")
	bonusTocando = false
	_jukebox()
		


func _WinAmarelo():
	playsound = false
	musicMp3.stop()
	winSoundFunc()
	animP.play("winamarelo")
	amiguinhos = false
	yield(get_tree().create_timer(animP.get_animation("winamarelo").length), "timeout")
	animP.play("winamarelobaza")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("cortinasentrada")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("tudobaza2")
	bonusTocando = false
	_jukebox()


func _WinAzul():
	playsound = false
	musicMp3.stop()
	winSoundFunc()
	animP.play("winazul")
	amiguinhos = false
	yield(get_tree().create_timer(animP.get_animation("winazul").length), "timeout")
	animP.play("winazulbaza")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("cortinasentrada")
	yield(get_tree().create_timer(1), "timeout")
	animP.play("tudobaza2")
	bonusTocando = false
	_jukebox()


func _WinAzul2():
	playsound = false
	musicMp3.stop()
	winSoundFunc()
	winazulLBL.text = "5000"
	animP.play("winazul")
	amiguinhos = false
	yield(get_tree().create_timer(animP.get_animation("winazul").length), "timeout")
	animP.play("winazulbaza")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("cortinasentrada")
	yield(get_tree().create_timer(1), "timeout")
	animP.play("tudobaza2")
	bonusTocando = false
	_jukebox()


func winSoundFunc():
	winMP3.play()
	yield(get_tree().create_timer(winMP3.stream.get_length()), "timeout")
	winMP3.stop()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_B:
			_entra()
			
			
func _on_KnifeSoundMP3_finished():
	knifeMP3.stop()


func _on_WinMP3_finished():
	winMP3.stop()



func _jukebox():
	if !jukebox.is_playing():
		jukebox.stream = musicAudio
		jukebox.play()
		yield(get_tree().create_timer(jukebox.stream.get_length()), "timeout")
		jukebox.stop()
