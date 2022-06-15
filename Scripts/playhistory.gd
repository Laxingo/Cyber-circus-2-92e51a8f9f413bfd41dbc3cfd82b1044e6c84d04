extends Node2D

onready var texto1 = get_node("1Texts")
onready var texto2 = get_node("2Texts")

var text1went

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_button_down():
	if!text1went:
		$Tween.interpolate_property(texto1, "position", Vector2(0,0), Vector2(-1487, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.interpolate_property(texto2, "position", Vector2(1870,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		text1went = true
#	elif text1went:


func _on_TextureButton2_button_down():
	if text1went:
		$Tween.interpolate_property(texto1, "position", Vector2(-1487,0), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.interpolate_property(texto2, "position", Vector2(0,0), Vector2(1870, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		text1went = false


func _on_ExitBtn_button_down():
	get_tree().change_scene("res://scenes/Main.tscn")
