extends Node2D


onready var animP = $AnimationPlayer
onready var tweenie = $Tween
onready var roda = $CyberCircusRouletteBonus
onready var facaAnim = $faca/AnimationPlayer

var prontaprarodar = false
var prontopraclicar = false


func _ready():
#	_entra()
	pass


func _process(delta):
	if prontaprarodar:
		roda.rotation_degrees = roda.rotation_degrees +2
	

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
	if prontopraclicar:
		facaAnim.play("1faca")

