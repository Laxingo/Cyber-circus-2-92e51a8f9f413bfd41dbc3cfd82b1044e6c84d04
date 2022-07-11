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
onready var palhacoAnim = $amiguinhos/Clown/AnimationPlayer
onready var coelhoAnim = $amiguinhos/Bunny/AnimationPlayer


var facaPos = Vector2(639, 169)

var prontaprarodar = false
var prontopraclicar = false

onready var random = RandomNumberGenerator.new()


onready var knifeSound = preload("res://sound/bonus/Bonus_KnifeThrow.mp3")
onready var music = preload("res://sound/bonus/Bonus_Music.mp3")
onready var transition1 = preload("res://sound/bonus/Bonus_Transition_In.mp3")
onready var transition2 = preload("res://sound/bonus/Bonus_Transition_Out.mp3")
onready var winSound = preload("res://sound/bonus/Bonus_Win.mp3")

onready var jukebox = $Jukebox
onready var musicAudio = preload("res://sound/music/Ambience.mp3")

onready  var knifeMP3 = $KnifeSoundMP3
onready var musicMp3 = $MusicMP3
onready var transitionMP3 = $TransMP3
onready var winMP3 = $WinMP3

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

func _process(delta):
	if playsound:
		bonusSound()
	if prontaprarodar:
		roda.rotation_degrees = roda.rotation_degrees + 250 * delta
	else:
		roda.rotation_degrees = roda.rotation_degrees
	
	if amiguinhos == true:
		if !comecou:
			comecou = true
			amiguinhPalhaco()
			amiguinhoCoelho()

func bonusTocando(yesorNo):
	return
func _entra():
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
	var num = random.randi_range(0, 3)
	if prontopraclicar:
		prontopraclicar = false
	
		if!faca1Thrown:
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
				facaAnim.play("facaf3")
				atiraFacaSOM() #substituir
				yield(get_tree().create_timer(0.6), "timeout")
				
		elif!faca2Thrown:
			faca2Thrown
		else:
			faca3Thrown
			
			
			
			
			
			

func atiraFacaSOM():
	knifeMP3.play()
	yield(get_tree().create_timer(knifeMP3.stream.get_length()), "timeout")
	knifeMP3.stop()

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
#	yield(get_tree().create_timer(2), "timeout")
#	animP.play("cortinasentrada")
#	yield(get_tree().create_timer(1), "timeout")
#	animP.play("tudobaza2")
#	bonusTocando = false
#	_jukebox()
	if !faca1Thrown:
		yield(get_tree().create_timer(2), "timeout")
		facaAnim2.play("facaentra")
		yield(get_tree().create_timer(1), "timeout")
		facaAnim2.play("click")
		prontopraclicar = true
		yield(get_tree().create_timer(facaAnim2.get_animation("click").length), "timeout")
		if prontopraclicar:
			facaAnim2.play("facaglow")
		


func _WinAmarelo():
	playsound = false
	musicMp3.stop()
	winSoundFunc()
	animP.play("winamarelo")
	amiguinhos = false
	yield(get_tree().create_timer(animP.get_animation("winamarelo").length), "timeout")
	animP.play("winamarelobaza")
#	yield(get_tree().create_timer(2), "timeout")
#	animP.play("cortinasentrada")
#	yield(get_tree().create_timer(2), "timeout")
#	animP.play("tudobaza2")
#	bonusTocando = false
#	_jukebox()

func _WinAzul():
	playsound = false
	musicMp3.stop()
	winSoundFunc()
	animP.play("winazul")
	amiguinhos = false
	yield(get_tree().create_timer(animP.get_animation("winazul").length), "timeout")
	animP.play("winazulbaza")
#	yield(get_tree().create_timer(2), "timeout")
#	animP.play("cortinasentrada")
#	yield(get_tree().create_timer(1), "timeout")
#	animP.play("tudobaza2")
#	bonusTocando = false
#	_jukebox()


func _WinAzul2():
	playsound = false
	musicMp3.stop()
	winSoundFunc()
	winazulLBL.text = "5000"
	animP.play("winazul")
	amiguinhos = false
	yield(get_tree().create_timer(animP.get_animation("winazul").length), "timeout")
	animP.play("winazulbaza")
#	yield(get_tree().create_timer(2), "timeout")
#	animP.play("cortinasentrada")
#	yield(get_tree().create_timer(1), "timeout")
#	animP.play("tudobaza2")
#	bonusTocando = false
#	_jukebox()


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
	pass # Replace with function body.


func _on_WinMP3_finished():
	winMP3.stop()
	pass # Replace with function body.



func _jukebox():
	if !jukebox.is_playing():
		jukebox.stream = musicAudio
		jukebox.play()
		yield(get_tree().create_timer(jukebox.stream.get_length()), "timeout")
		jukebox.stop()
