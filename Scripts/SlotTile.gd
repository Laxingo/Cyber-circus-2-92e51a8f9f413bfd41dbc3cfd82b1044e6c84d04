extends Node2D
class_name SlotTile

var size :Vector2;
var tileName;
var playing = false;

func _ready():
  pass

func set_icon(tex):
	$Sprite/A.visible = (tex =="A");
	$Sprite/Bunny.visible = (tex =="bunny");
	$Sprite/Clown.visible = (tex =="clown");
	$Sprite/Elephant.visible = (tex =="elephant");
	$Sprite/J.visible = (tex =="J");
	$Sprite/K.visible = (tex =="K");
	$Sprite/Lion.visible = (tex =="lion");
	$Sprite/Strongman.visible = (tex =="strongman");
	$Sprite/Q.visible = (tex =="Q");
	$Sprite/Roulette.visible = (tex =="roulette");

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



func animate_icon(symbol):
	if !playing:
		if (symbol =="A"):
			$Sprite/A/AnimationPlayer.play("A_Sweep")
			playing = true
			var moldura = $Sprite/A/Quadrado
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="bunny"):
			$Sprite/Bunny/AnimationPlayer.play("bunny")
			playing = true
			var moldura = $Sprite/Bunny/Moldura
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="clown"):
			$Sprite/Clown/AnimationPlayer.play("palhaço")
			playing = true
			var moldura = $Sprite/Clown/Estrelas
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="elephant"):
			$Sprite/Elephant/AnimationPlayer.play("ele_bola")
			playing = true
			var moldura = $Sprite/Elephant/Moldura
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="J"):
			$Sprite/J/AnimationPlayer.play("J_Sweep")
			playing = true
			var moldura = $Sprite/J/Quadrado
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="K"):
			$Sprite/K/AnimationPlayer.play("K_Sweep")
			playing = true
			var moldura = $Sprite/K/Quadrado
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="lion"):
			$Sprite/Lion/AnimationPlayer.play("lion_win")
			playing = true
			var moldura = $Sprite/Lion/Espirais
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="strongman"):
			$Sprite/Strongman/AnimationPlayer.play("b")
			playing = true
			var moldura = $Sprite/Strongman/Moldura
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="Q"):
			$Sprite/Q/AnimationPlayer.play("Q_Sweep")
			playing = true
			var moldura = $Sprite/Q/Quadrado
			moldura.modulate = Color(1, 0.843, 0)
			yield(get_tree().create_timer(3), "timeout")
			playing = false
		elif(symbol =="roulette"):
			pass

func animate_icon_idle(symbol):
	print("animate_icon_idle");
	if (symbol =="A"):
		var moldura = $Sprite/A/Quadrado
		moldura.modulate = Color( 1, 1, 1, 1 );
	elif(symbol =="bunny"):
		var moldura = $Sprite/Bunny/Moldura;
		moldura.modulate = Color( 1, 1, 1, 1 );
		$Sprite/Bunny/AnimationPlayer.play("bunny_idle");
	elif(symbol =="clown"):
		var moldura = $Sprite/Clown/Estrelas;
		moldura.modulate = Color( 1, 1, 1, 1 );
		$Sprite/Clown/AnimationPlayer.play("pidle")
	elif(symbol =="elephant"):
		var moldura = $Sprite/Elephant/Moldura
		moldura.modulate = Color( 1, 1, 1, 1 );
		$Sprite/Elephant/AnimationPlayer.play("ele_bola_idle")
	elif(symbol =="J"):
		var moldura = $Sprite/J/Quadrado
		moldura.modulate = Color( 1, 1, 1, 1 );
	elif(symbol =="K"):
		var moldura = $Sprite/K/Quadrado
		moldura.modulate = Color( 1, 1, 1, 1 );
	elif(symbol =="lion"):
		var moldura = $Sprite/Lion/Espirais
		moldura.modulate = Color( 1, 1, 1, 1 );
		$Sprite/Lion/AnimationPlayer.play("lion_idle")
	elif(symbol =="strongman"):
		var moldura = $Sprite/Strongman/Moldura
		moldura.modulate = Color( 1, 1, 1, 1 );
		$Sprite/Strongman/AnimationPlayer.play("bomba_idle")
	elif(symbol =="Q"):
		var moldura = $Sprite/Q/Quadrado
		moldura.modulate = Color( 1, 1, 1, 1 );
	elif(symbol =="roulette"):
		pass
