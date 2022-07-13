extends Node2D

const SlotTile := preload("res://scenes/Tile.tscn")

onready var main = load("res://Scripts/Main.gd").new()
onready var bonusLvl = load("res://Scripts/BonusLvl.gd").new()

const SPIN_UP_DISTANCE = 100.0
signal stopped

export(int,1,20) var reels := 5
export(int,1,20) var tiles_per_reel :=3 
export(float,0,10) var runtime := 2
export(float,0.1,10) var speed := 5.0
export(float,0,2) var reel_delay := 0.2

export(float,0,10) var runtime1 := 2
export(float,0,10) var speed1 := 5.0
export(float,0,10) var runtime2 := 1
export(float,0,10) var speed2 := 10

onready var size := get_viewport_rect().size
onready var tile_size := size / Vector2(reels, tiles_per_reel)
onready var speed_norm := speed * tiles_per_reel
onready var extra_tiles := int(ceil(SPIN_UP_DISTANCE / tile_size.y) * 2)

onready var rows := tiles_per_reel + extra_tiles
onready var cells = rows * reels

onready var random = RandomNumberGenerator.new()

#var result_icon

enum State {OFF, ON, STOPPED}
var state = State.OFF
var result := {}
var tile_name

var tiles := []
const grid_pos := []

onready var expected_runs :int = int(runtime * speed_norm)
var tiles_moved_per_reel := []
var runs_stopped := 0
var total_runs : int

export(Array, String) var symbolName := ["bunny", "strongman", "elephant", "roulette", "clown", "Q", 
"K","J", "A"];


var prizeNb = 3
var prizeMasks = [];
var prizesToAnim = [];

var prizeType;
var mediumPrizeIdx = 3;
var bigPrizeIdx = 5;

onready var reelMelo1 = preload("res://sound/reels spin/Melody_1.mp3")
onready var reelMelo2 = preload("res://sound/reels spin/Melody_2.mp3")
onready var reelMelo3 = preload("res://sound/reels spin/Melody_3.mp3")
onready var reelMelo4 = preload("res://sound/reels spin/Melody_4.mp3")
onready var melnumber = 1
var meloplayed = false
onready var reelMelo = $ReelMelody


onready var reelAudioPlayer1 = $ReelsAudio
onready var reelAudioPlayer2 = $ReelsAudio2
onready var reelAudioPlayer3 = $ReelsAudio3
onready var reelAudioPlayer4 = $ReelsAudio4
onready var reelAudioPlayer5 = $ReelsAudio5
onready var reelSpinning = preload("res://sound/reels spin/Reel_Spinning.mp3")
onready var reelStopping = preload("res://sound/reels spin/Reel_Stopping.mp3")

onready var tweenie = $Tween
var reelsPlayers = [reelAudioPlayer1, reelAudioPlayer2, reelAudioPlayer3, reelAudioPlayer4, reelAudioPlayer5]


var smallWinToca = false
var mediumWinToca = false
var goodWinToca = false
var bigWinToca = false
var ola = false

onready var tenPressed = false
onready var twentyPressed = false
onready var fiftyPressed = false
onready var hundredPressed = false
onready var playAgain = true

var tenTimes = 0
var twentyfiveTimes = 0
var fiftyTimes = 0
var hundredTimes = 0


func _ready():
	runtime = runtime1
	speed = speed1
	setPrizeMasks();
	#setPrizeMasks2()
	for col in reels:
		grid_pos.append([])
		tiles_moved_per_reel.append(0)
		for row in range(rows): 
			grid_pos[col].append(Vector2(col, row - 0.9 *extra_tiles) * tile_size) 
			_add_tile(col, row)

func _process(_delta):
	if tenPressed:
		if tenTimes < 10:
			if playAgain:
				start()
				playAgain = false
				tenTimes += 1
		else:
			tenPressed = false
			tenTimes = 0
			playAgain = true
	if twentyPressed:
		if twentyfiveTimes < 25:
			if playAgain:
				start()
				playAgain = false
				twentyfiveTimes += 1
		else:
			twentyPressed = false
			twentyfiveTimes = 0
			playAgain = true
	if fiftyPressed:
		if fiftyTimes < 50:
			if playAgain:
				start()
				playAgain = false
				fiftyTimes += 1
		else:
			fiftyPressed = false
			fiftyTimes = 0
			playAgain = true
	if hundredPressed:
		if hundredTimes < 100:
			if playAgain:
				start()
				playAgain = false
				hundredTimes += 1
		else:
			hundredPressed = false
			hundredTimes = 0
			playAgain = true

func setPrizeMasks():
	prizeMasks.push_back(0b110000000000000);
	prizeMasks.push_back(0b000001100000000);
	prizeMasks.push_back(0b000000000011000);
	prizeMasks.push_back(0b000000000011111);
	prizeMasks.push_back(0b000001111100000);
	prizeMasks.push_back(0b111110000000000);
	prizeMasks.push_back(0b100010101000100);
	prizeMasks.push_back(0b001000101010001);
	prizeMasks.push_back(0b110110010000000);
	prizeMasks.push_back(0b000000010011011);
	prizeMasks.push_back(0b000001000101110);
	prizeMasks.push_back(0b011101000100000);
	prizeMasks.push_back(0b010101010100000);
	prizeMasks.push_back(0b1111111111111111);


func _add_tile(col :int, row :int) -> void:
	tiles.append(SlotTile.instance())
	var tile := get_tile(col, row) 
	var randomSymbol  = _randomIcones()
	
	assert(tile.get_node('Tween').connect("tween_completed", self, "_on_tile_moved", [col], CONNECT_DEFERRED)==0);
	tile.set_icon(randomSymbol)
	tile.set_size(tile_size)
	tile.set_name(randomSymbol)
	tile.position = grid_pos[col][row]
	tile.set_speed(speed_norm)
	tile.animate_icon_idle(randomSymbol)
	add_child(tile)

func get_tile(col :int, row :int) -> SlotTile:
  return tiles[(col * rows) + row]

func start() -> void:
	if state == State.OFF: 
		state = State.ON 
		total_runs = expected_runs
		_get_result()
	for reel in reels:
		_spin_reel(reel)
		
		if reel == 0:
			if !reelMelo.is_playing():
				reelMelodyPlay()
				reelMelo.play()
			meloplayed = true
		if reel == 0:
			reelSpinPlay(reel)
		elif reel == 1:
			reelSpinPlay(reel)
		elif reel == 2:
			reelSpinPlay(reel)
		elif reel == 3:
			reelSpinPlay(reel)
		elif reel == 4:
			reelSpinPlay(reel)
		if reel_delay > 0:
			   yield(get_tree().create_timer(reel_delay), "timeout")
	if melnumber <4:
		melnumber= melnumber +1
	else:
		melnumber = 1
	meloplayed= false
  
func stop():
	state = State.STOPPED
	runs_stopped = current_runs()
	total_runs = runs_stopped + tiles_per_reel + 1

func _stop() -> void:
	for reel in reels:
		tiles_moved_per_reel[reel] = 0
		state = State.OFF
		emit_signal("stopped")

		if reel == reels - 1:
			buildResultMasks();
			animPrizes();
			playAgain = true


func _spin_reel(reel :int) -> void:
  for row in rows:
   _move_tile(get_tile(reel, row))

func _move_tile(tile :SlotTile) -> void:
	tile.spin_up()
	modulate.a = 1
	yield(tile.get_node("Animations"), "animation_finished")
	tile.move_by(Vector2(0, tile_size.y))

func reelMelodyPlay():
	if melnumber == 1:
		reelMelo.stream = reelMelo1
		yield(get_tree().create_timer(reelMelo.stream.get_length()), "timeout")
		reelMelo.stop()
	elif melnumber == 2:
		reelMelo.stream = reelMelo2
		yield(get_tree().create_timer(reelMelo.stream.get_length()), "timeout")
		reelMelo.stop()
	elif melnumber == 3:
		reelMelo.stream = reelMelo3
		yield(get_tree().create_timer(reelMelo.stream.get_length()), "timeout")
		reelMelo.stop()
	elif melnumber == 4:
		reelMelo.stream = reelMelo4
		yield(get_tree().create_timer(reelMelo.stream.get_length()), "timeout")
		reelMelo.stop()

func reelSpinPlay(reelnmbr):
	if reelnmbr == 0:
		if !reelAudioPlayer1.is_playing():
			reelAudioPlayer1.stream = reelSpinning
			reelAudioPlayer1.play()
			yield(get_tree().create_timer(runtime +0.6), "timeout")
			reelAudioPlayer1.stream = reelStopping
			reelAudioPlayer1.play()
			yield(get_tree().create_timer(reelAudioPlayer1.stream.get_length()), "timeout")
			reelAudioPlayer1.stop()
	elif reelnmbr == 1:
		if !reelAudioPlayer2.is_playing():
			reelAudioPlayer2.stream = reelSpinning
			reelAudioPlayer2.play()
			yield(get_tree().create_timer(runtime+0.6), "timeout")
			reelAudioPlayer2.stream = reelStopping
			reelAudioPlayer2.play()
			yield(get_tree().create_timer(reelAudioPlayer2.stream.get_length()), "timeout")
			reelAudioPlayer2.stop()
	elif reelnmbr == 2:
		if !reelAudioPlayer3.is_playing():
			reelAudioPlayer3.stream = reelSpinning
			reelAudioPlayer3.play()
			yield(get_tree().create_timer(runtime+0.6), "timeout")
			reelAudioPlayer3.stream = reelStopping
			reelAudioPlayer3.play()
			yield(get_tree().create_timer(reelAudioPlayer3.stream.get_length()), "timeout")
			reelAudioPlayer3.stop()
	elif reelnmbr == 3:
		if !reelAudioPlayer4.is_playing():
			reelAudioPlayer4.stream = reelSpinning
			reelAudioPlayer4.play()
			yield(get_tree().create_timer(runtime+0.6), "timeout")
			reelAudioPlayer4.stream = reelStopping
			reelAudioPlayer4.play()
			yield(get_tree().create_timer(reelAudioPlayer4.stream.get_length()), "timeout")
			reelAudioPlayer4.stop()
	elif reelnmbr == 4:
		if !reelAudioPlayer5.is_playing():
			reelAudioPlayer5.stream = reelSpinning
			reelAudioPlayer5.play()
			yield(get_tree().create_timer(runtime+0.6), "timeout")
			reelAudioPlayer5.stream = reelStopping
			reelAudioPlayer5.play()
			yield(get_tree().create_timer(reelAudioPlayer5.stream.get_length()), "timeout")
			reelAudioPlayer5.stop()
		reelnmbr = 1
	
  
func _on_tile_moved(tile: SlotTile, _nodePath, column) -> void:
	tiles_moved_per_reel[column] += 1;
	var reel_runs := current_runs(column);
	if (tile.position.y > grid_pos[0][grid_pos.size() - 1].y):
		tile.position.y = grid_pos[0][0].y;

	var randomicon = _randomIcones();
	tile.set_icon(randomicon);
	tile.set_name(randomicon);
	tile.animate_icon_idle(randomicon);

	if (state != State.OFF && reel_runs != total_runs):
		tile.move_by(Vector2(0, tile_size.y));
	else:
		tile.spin_down();
		if column == reels - 1:
			_stop();

func current_runs(reel := 0) -> int:
  return int(ceil(float(tiles_moved_per_reel[reel]) / rows))

func _randomIcones() -> String:
	random.randomize();
	var num = random.randi_range(0, symbolName.size()-1);
	tile_name = symbolName[num];
	return tile_name;

func _get_result() -> void:
  result = {
	"tiles": [
	  [ 0,0,0,0 ],
	  [ 0,0,0,0 ],
	  [ 0,0,0,0 ],
	  [ 0,0,0,0 ],
	  [ 0,0,0,0 ]
	]}

func buildResultMasks():
	var resultSymbols = [];
	var resultMasks = [];
	#var tileAnim = SlotTile
	
	for r in range(0, rows):
		if(r < rows - tiles_per_reel):
			continue;
		for l in range(0, reels):
			var tile = get_tile(l , r)
			resultSymbols.push_back(tile.tileName);
	for p in symbolName.size():
		var _tmpResultMask = 0b0;
		for i in resultSymbols.size():
			_tmpResultMask |= int(symbolName[p] == resultSymbols[i]) << resultSymbols.size() - 1 - i;
		resultMasks.push_back(_tmpResultMask);
	
	prizesToAnim = [];
	prizesToAnim = getPrizes(resultMasks);


func getPrizes(result_masks):
	var prizeInfo = [];
	for i in result_masks.size():

		for c in prizeMasks.size():
			if (result_masks[i] & prizeMasks[c] == prizeMasks[c]):
				prizeInfo.push_back([i, c]) # First position -> Synbol IDX; Second Position -> Prize IDX
				
				if(c >= bigPrizeIdx):
					prizeType = "Good";
				elif(c >= mediumPrizeIdx):
					prizeType = "Medium";
				else:
					prizeType="Small";

	return prizeInfo;


func animPrizes():
	if(!prizesToAnim.size()):
		return;

	var winTile;
	var line;
	var column;

	for p in prizesToAnim.size():
		for i in cells:
			var _pcell = reels * tiles_per_reel - 1 - i;
			modulate.a = 0.6;
			var prizeID = symbolName[prizesToAnim[p][0]];
			if(prizeMasks[prizesToAnim[p][1]] & 1<<i):
				column = _pcell % reels;
				line = int(floor((extra_tiles * rows + _pcell) / rows));
				winTile = get_tile(column, line);
				winTile.modulate.a = 2;
				winTile.animate_icon(prizeID);
				givePoints(prizeID);
				

var pointsToGive
func givePoints(prizeID):

	if prizeID == "bunny":
		if prizeType == "Good":
			pointsToGive = 500
		elif prizeType == "Medium":
			pointsToGive = 150
		elif prizeType == "Small":
			pointsToGive = 50
			
	elif prizeID == "lion":
		pass
		
	elif prizeID == "strongman":
		if prizeType == "Good":
			pointsToGive = 1000
		elif prizeType == "Medium":
			pointsToGive = 250
		elif prizeType == "Small":
			pointsToGive = 50
			
	elif prizeID == "roulette":
		bonusLvl._entra()
		
	elif prizeID == "A":
		if prizeType == "Good":
			pointsToGive = 150
		elif prizeType == "Medium":
			pointsToGive = 30
		elif prizeType == "Small":
			pointsToGive = 10
			
	elif prizeID == "K":
		if prizeType == "Good":
			pointsToGive = 150
		elif prizeType == "Medium":
			pointsToGive = 30
		elif prizeType == "Small":
			pointsToGive = 10
			
	elif prizeID == "Q":
		if prizeType == "Good":
			pointsToGive = 5
		elif prizeType == "Medium":
			pointsToGive = 25
		elif prizeType == "Small":
			pointsToGive = 5
			
	elif prizeID == "J":
		if prizeType == "Good":
			pointsToGive = 100
		elif prizeType == "Medium":
			pointsToGive = 25
		elif prizeType == "Small":
			pointsToGive = 5
			
	elif prizeID == "clown":
		pointsToGive = 5 * main.bet
		
	elif prizeID == "elephant":
		if prizeType == "Good":
			pointsToGive = 300
		elif prizeType == "Medium":
			pointsToGive = 75
		elif prizeType == "Small":
			pointsToGive = 25
	
	if pointsToGive > 250:
		bigWinToca=true
	elif pointsToGive >100:
		goodWinToca = true
	elif pointsToGive>30:
		mediumWinToca = true
	else:
		smallWinToca = true

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_R:
			symbolName = ["roulette"];
		elif event.scancode == KEY_T:
			symbolName = ["bunny"];
		elif event.scancode == KEY_C:
			symbolName = ["clown"];
		elif event.scancode == KEY_S:
			symbolName = ["strongman"];
		elif event.scancode == KEY_L:
			symbolName = ["lion"];
		elif event.scancode == KEY_E:
			symbolName = ["elephant"];
		elif event.scancode == KEY_A:
			symbolName = ["A"];
		elif event.scancode == KEY_J:
			symbolName = ["J"];
		elif event.scancode == KEY_Q:
			symbolName = ["Q"];


func _on_10_button_down(): 
	tenPressed = true

func _on_25_button_down():
	twentyPressed = true

func _on_50_button_down():
	fiftyPressed = true

func _on_100_button_down():
	hundredPressed = true

var fastOn = false
func _on_fast_button_down():
	if fastOn:
		speed = speed1
		runtime = runtime1
		speed_norm = speed * tiles_per_reel
		expected_runs = int(runtime * speed_norm)

		fastOn = false
	else:
		speed = speed2
		runtime = runtime2
		speed_norm = speed * tiles_per_reel
		expected_runs = int(runtime * speed_norm)
		
		fastOn = true
	pass # Replace with function body.
