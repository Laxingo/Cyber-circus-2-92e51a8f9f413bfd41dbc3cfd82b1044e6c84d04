extends Node2D


onready var animP = $AnimationPlayer
onready var tweenie = $Tween
onready var roda = $Roda
onready var facaAnim = $faca/AnimationPlayer
onready var faca = $faca
onready var facaSprite = $faca/KnifeSpritesheet
onready var facaHitbox = $FacaHitbox
onready var hitboxes = $Roda/Hitboxes


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
	animP.play("3rodaluzentra")
	yield(get_tree().create_timer(animP.get_animation("3rodaluzentra").length + 1), "timeout")
	animP.play("4rodaroda")
	yield(get_tree().create_timer(4), "timeout")
	prontaprarodar = true
	yield(get_tree().create_timer(3), "timeout")
	facaAnim.play("facaentra")
	yield(get_tree().create_timer(2), "timeout")
	prontopraclicar = true
	


func _on_RodaBtn_pressed():
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
		elif num == 2:
			facaAnim.play("3faca")
			yield(get_tree().create_timer(0.6), "timeout")
			prontaprarodar = false
			facaHitbox.position = facaSprite.position



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
	_WinAzul()

func _on_Amarelo_4_area_entered(area):
	_WinAzul()



func _WinRosa():
	print("ROSA")
	animP.play("winrosa")

func _WinAmarelo():
	print("AMARELO")
	animP.play("winamarelo")

func _WinAzul():
	print("AZUL")
	animP.play("winazul")


func _on_BonusBtn_button_down():
	_entra()
