extends Node2D
class_name SlotTile

var size :Vector2
var tileName

func _ready():
  pass

func set_icon(tex):
	if (tex =="A"):
		$Sprite/A.visible = true
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= false
		$Sprite/K.visible= false
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= false
	elif(tex =="bunny"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= true
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= false
		$Sprite/K.visible= false
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= false
	elif(tex =="clown"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = true
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= false
		$Sprite/K.visible= false
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= false
	elif(tex =="elephant"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= true
		$Sprite/J.visible= false
		$Sprite/K.visible= false
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= false
	elif(tex =="J"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= true
		$Sprite/K.visible= false
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= false
	elif(tex =="K"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= false
		$Sprite/K.visible= true
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= false
	elif(tex =="lion"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= false
		$Sprite/K.visible= false
		$Sprite/Lion.visible= true
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= false
	elif(tex =="strongman"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= false
		$Sprite/K.visible= false
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= true
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= false
	elif(tex =="Q"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= false
		$Sprite/K.visible= false
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= true
		$Sprite/Roulette.visible= false
	elif(tex =="roulette"):
		$Sprite/A.visible = false
		$Sprite/Bunny.visible= false
		$Sprite/Clown.visible = false
		$Sprite/Elephant.visible= false
		$Sprite/J.visible= false
		$Sprite/K.visible= false
		$Sprite/Lion.visible= false
		$Sprite/Strongman.visible= false
		$Sprite/Q.visible= false
		$Sprite/Roulette.visible= true
	set_size(size)

func set_name(nam):
	tileName = nam

func set_size(new_size: Vector2):
	size = new_size
	$Sprite.scale = size / $Sprite.texture.get_size()
  
func set_speed(speed):
  $Tween.playback_speed = speed
  
func move_to(to: Vector2):
	$Tween.interpolate_property(self, "position", position, to, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func move_by(by: Vector2):
  move_to(position + by)
  
func spin_up():
  $Animations.play('SPIN_UP')
  
func spin_down():
	$Animations.play('SPIN_DOWN')

var playing = false
func animate_icon(symbol):
	if !playing:
		if (symbol =="A"):
			$Sprite/A/AnimationPlayer.play("A_Sweep")
			playing = true
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="bunny"):
			$Sprite/Bunny/AnimationPlayer.play("bunny")
			playing = true
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="clown"):
			$Sprite/Clown/AnimationPlayer.play("palhaço")
			playing = true
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="elephant"):
			$Sprite/Elephant/AnimationPlayer.play("ele_bola")
			playing = true
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="J"):
			$Sprite/J/AnimationPlayer.play("J_Sweep")
			playing = true
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="K"):
			$Sprite/K/AnimationPlayer.play("K_Sweep")
			playing = true
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="lion"):
#			$Sprite/Lion/AnimationPlayer.play("lion_win")
#			playing = true
#			yield(get_tree().create_timer(3), "timeout")
#			playing = false
			pass
		elif(symbol =="strongman"):
			$Sprite/Strongman/Viewport/AnimationPlayer.play("b1")
			playing = true
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="Q"):
			$Sprite/Q/AnimationPlayer.play("Q_Sweep")
			playing = true
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="roulette"):
			pass

func animate_icon_idle(symbol):
	if (symbol =="A"):
		pass
	elif(symbol =="bunny"):
		$Sprite/Bunny/AnimationPlayer.play("bunny_idle")
	elif(symbol =="clown"):
		$Sprite/Clown/AnimationPlayer.play("pidle")
	elif(symbol =="elephant"):
		$Sprite/Elephant/AnimationPlayer.play("ele_bola_idle")
	elif(symbol =="J"):
		pass
	elif(symbol =="K"):
		pass
	elif(symbol =="lion"):
		$Sprite/Lion/AnimationPlayer.play("lion_idle")
	elif(symbol =="strongman"):
		$Sprite/Strongman/Viewport/AnimationPlayer.play("bomba_idle")
	elif(symbol =="Q"):
		pass
	elif(symbol =="roulette"):
		pass
