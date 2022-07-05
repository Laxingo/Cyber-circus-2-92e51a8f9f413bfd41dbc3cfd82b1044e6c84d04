extends Node2D


onready var animP = $AnimationPlayer
onready var tweenie = $Tween
onready var roda = $Roda
onready var facaAnim = $faca/AnimationPlayer
onready var faca = $faca
onready var facaSprite = $faca/KnifeSpritesheet
onready var facaHitbox = $FacaHitbox
onready var hitboxes = $Roda/Hitboxes
onready var winazulLBL = $winazul
onready var glow = $faca/KnifeGlow

var facaPos = Vector2(639, 169)

var prontaprarodar = false
var prontopraclicar = false

onready var random = RandomNumberGenerator.new()


func _ready():
	pass


func _process(delta):
	if prontaprarodar:
		roda.rotation_degrees = roda.rotation_degrees +2
	else:
		roda.rotation_degrees = roda.rotation_degrees

func _entra():
	self.visible = true
	animP.play("1bonusentrada")
	yield(get_tree().create_timer(animP.get_animation("1bonusentrada").length + 0.2), "timeout")
	animP.play("2throwtheknife")
	yield(get_tree().create_timer(animP.get_animation("2throwtheknife").length +0.5), "timeout")
	animP.play("tudobaza")
	yield(get_tree().create_timer(animP.get_animation("tudobaza").length + 1), "timeout")
	animP.play("3rodaluzentra")
	yield(get_tree().create_timer(animP.get_animation("tudobaza").length + 1), "timeout")
	animP.play("4rodaroda")
	yield(get_tree().create_timer(4), "timeout")
	prontaprarodar = true
	yield(get_tree().create_timer(3), "timeout")
	facaAnim.play("facaentra")
	yield(get_tree().create_timer(1), "timeout")
	facaAnim.play("click")
	prontopraclicar = true
	yield(get_tree().create_timer(facaAnim.get_animation("click").length), "timeout")
	if prontopraclicar:
		facaAnim.play("facaglow")


func _on_RodaBtn_pressed():
	glow.visible = false
	random.randomize()
	var num = random.randi_range(0, 2)
	if prontopraclicar:
		prontopraclicar = false
		if num == 0:
			facaAnim.play("1faca")
			yield(get_tree().create_timer(0.6), "timeout")
			prontaprarodar = false
			_WinAmarelo()
		elif num == 1:
			facaAnim.play("2faca")
			yield(get_tree().create_timer(0.6), "timeout")
			prontaprarodar = false
			facaHitbox.position = facaSprite.position
			yield(get_tree().create_timer(0.6), "timeout")
			facaHitbox.position = facaPos
		elif num == 2:
			facaAnim.play("3faca")
			yield(get_tree().create_timer(0.6), "timeout")
			prontaprarodar = false
			facaHitbox.position = facaSprite.position 
			yield(get_tree().create_timer(0.6), "timeout")
			facaHitbox.position = facaPos



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
	animP.play("winrosa")
	yield(get_tree().create_timer(6), "timeout")
	animP.play("winrosabaza")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("cortinasentrada")
	yield(get_tree().create_timer(1), "timeout")
	animP.play("tudobaza2")
	

func _WinAmarelo():
	animP.play("winamarelo")
	yield(get_tree().create_timer(6), "timeout")
	animP.play("winamarelobaza")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("cortinasentrada")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("tudobaza2")

func _WinAzul():
	animP.play("winazul")
	yield(get_tree().create_timer(6), "timeout")
	animP.play("winazulbaza")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("cortinasentrada")
	yield(get_tree().create_timer(1), "timeout")
	animP.play("tudobaza2")

func _WinAzul2():
	winazulLBL.text = "5000"
	animP.play("winazul")
	yield(get_tree().create_timer(6), "timeout")
	animP.play("winazulbaza")
	yield(get_tree().create_timer(2), "timeout")
	animP.play("cortinasentrada")
	yield(get_tree().create_timer(1), "timeout")
	animP.play("tudobaza2")


func _on_BonusBtn_button_down():
	print("H")
	_entra()
