extends Node2D

onready var texto1 = get_node("symbolspayout")
onready var texto2 = get_node("wild")
onready var texto3 = get_node("scatter")
onready var texto4 = get_node("prizelines")

var text1went
var text2went
var text3went
var text4went

func _ready():
	pass 


func _on_TextureButton_button_down():
	if!text1went:
		$Tween.interpolate_property(texto1, "position", Vector2(0,0), Vector2(-2015.3, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.interpolate_property(texto2, "position", Vector2(1870,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		text1went = true
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


func _on_TextureButton2_button_down():
	if text1went:
		if !text2went:
			$Tween.interpolate_property(texto1, "position", Vector2(-2015.3,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			$Tween.interpolate_property(texto2, "position", Vector2(0,0), Vector2(1870, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			text1went = false
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


func _on_ExitBtn_button_down():
	get_tree().change_scene("res://scenes/Main.tscn")
