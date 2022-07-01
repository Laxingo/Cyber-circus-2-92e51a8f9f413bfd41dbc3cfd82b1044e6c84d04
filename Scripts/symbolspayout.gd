extends Node2D

onready var texto1 = get_node("symbolspayout")
onready var texto2 = get_node("wild")
onready var texto3 = get_node("scatter")
onready var texto4 = get_node("prizelines")
onready var texto5 = get_node("bonus")
onready var lionanim = $wild/Lion/AnimationPlayer
onready var clownanim = $scatter/AnimationPlayer

var text1went
var text2went
var text3went
var text4went
var text5went

func _ready():
	lionanim.play("lion_win")
	clownanim.play("New Anim")
	pass 


func _on_TextureButton_button_down():
	if!text1went:
		$TextureButton2.visible = false
		$Tween.interpolate_property(texto1, "position", Vector2(0,0), Vector2(-2015.3, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.interpolate_property(texto2, "position", Vector2(1870,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		text1went = true
		$TextureButton2.visible = true
	elif text1went:
		if !text2went:
			$Tween.interpolate_property(texto2, "position", Vector2(0,0), Vector2(-2015.3, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			$Tween.interpolate_property(texto3, "position", Vector2(1870,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			text2went = true
		elif text2went:
			if !text3went:
				$Tween.interpolate_property(texto3, "position", Vector2(0,0), Vector2(-2015.3, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				$Tween.interpolate_property(texto4, "position", Vector2(1870,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				text3went = true
			elif text3went:
				if !text4went:
					$Tween.interpolate_property(texto4, "position", Vector2(0,0), Vector2(-2015.3, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					$Tween.start()
					$Tween.interpolate_property(texto5, "position", Vector2(1870,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					$Tween.start()
					text4went = true
					$TextureButton.visible = false


func _on_TextureButton2_button_down():
	if text1went:
		if !text2went:
			$Tween.interpolate_property(texto1, "position", Vector2(-2015.3,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			$Tween.interpolate_property(texto2, "position", Vector2(0,0), Vector2(1870, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			text1went = false
			$TextureButton2.visible = false
			
		elif text2went:
			if!text3went:
				$Tween.interpolate_property(texto2, "position", Vector2(-2015.3,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				$Tween.interpolate_property(texto3, "position", Vector2(0,0), Vector2(1870, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				text2went = false
			elif text3went:
				if!text4went:
					$Tween.interpolate_property(texto3, "position", Vector2(-2015.3,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					$Tween.start()
					$Tween.interpolate_property(texto4, "position", Vector2(0,0), Vector2(1870, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					$Tween.start()
					text3went = false
				elif text4went:
					if!text5went:
						$Tween.interpolate_property(texto4, "position", Vector2(-2015.3,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
						$Tween.start()
						$Tween.interpolate_property(texto5, "position", Vector2(0,0), Vector2(1870, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
						$Tween.start()
						text4went = false
						$TextureButton.visible = true


func _on_ExitBtn_button_down():
	get_tree().change_scene("res://scenes/Main.tscn")
