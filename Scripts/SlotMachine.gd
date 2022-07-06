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

onready var size := get_viewport_rect().size
onready var tile_size := size / Vector2(reels, tiles_per_reel)
onready var speed_norm := speed * tiles_per_reel
onready var extra_tiles := int(ceil(SPIN_UP_DISTANCE / tile_size.y) * 2)

onready var rows := tiles_per_reel + extra_tiles
onready var cells = rows * reels

onready var random = RandomNumberGenerator.new()

var result_icon

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

export(Array, String) var symbolName := ["bunny", "lion","strongman", 
"roulette","A", "J", "K", "Q", "clown", "elephant"];

var bunny = 0
var clown= 0
var elephant= 0
var j= 0
var k= 0
var lion= 0
var malabare= 0
var strongman= 0
var q= 0

var prizeNb = 3
var prizeMasks = [];
var prizeMasks2 = [];
var prizesToAnim = [];

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

var reelsPlayers = [reelAudioPlayer1, reelAudioPlayer2, reelAudioPlayer3, reelAudioPlayer4, reelAudioPlayer5]

func _ready():
	setPrizeMasks();
	setPrizeMasks2()
	for col in reels:
		grid_pos.append([])
		tiles_moved_per_reel.append(0)
		for row in range(rows): 
			grid_pos[col].append(Vector2(col, row - 0.9 *extra_tiles) * tile_size) 
			_add_tile(col, row)

func setPrizeMasks():
	prizeMasks.push_back(0b000000000011111);
	prizeMasks.push_back(0b000001111100000);
	prizeMasks.push_back(0b110000000000000);
	prizeMasks.push_back(0b001100000000000);
	prizeMasks.push_back(0b111110000000000);
	prizeMasks.push_back(0b100010101000100);
	prizeMasks.push_back(0b001000101010001);
	prizeMasks.push_back(0b110110010000000);
	prizeMasks.push_back(0b000000010011011);
	prizeMasks.push_back(0b000001000101110);
	prizeMasks.push_back(0b011101000100000);
	prizeMasks.push_back(0b010101010100000);
func setPrizeMasks2():
	prizeMasks2.push_back(0b111111111111111);

func _add_tile(col :int, row :int) -> void:
	tiles.append(SlotTile.instance())
	var tile := get_tile(col, row) 
	var randomSymbol  = _randomIcones()
	tile.get_node('Tween').connect("tween_completed", self, "_on_tile_moved", [], CONNECT_DEFERRED)
	tile.set_icon(randomSymbol)
	tile.set_size(tile_size)
	tile.set_name(tile_name)
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
		if reel == 0:
			if !reelMelo.is_playing():
				reelMelodyPlay()
				reelMelo.play()
			meloplayed = true
		_spin_reel(reel)
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
	if state == State.OFF:
		buildResultMasks();
		animPrizes();
		

func _spin_reel(reel :int) -> void:
  for row in rows:
   _move_tile(get_tile(reel, row))

func _move_tile(tile :SlotTile) -> void:
  tile.spin_up()
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
			print("4")
			yield(get_tree().create_timer(runtime+0.6), "timeout")
			reelAudioPlayer4.stream = reelStopping
			reelAudioPlayer4.play()
			yield(get_tree().create_timer(reelAudioPlayer4.stream.get_length()), "timeout")
			reelAudioPlayer4.stop()
			print("4 over")
	elif reelnmbr == 4:
		if !reelAudioPlayer5.is_playing():
			reelAudioPlayer5.stream = reelSpinning
			reelAudioPlayer5.play()
			print("5")
			yield(get_tree().create_timer(runtime+0.6), "timeout")
			reelAudioPlayer5.stream = reelStopping
			reelAudioPlayer5.play()
			yield(get_tree().create_timer(reelAudioPlayer5.stream.get_length()), "timeout")
			reelAudioPlayer5.stop()
			print("5 over")
		reelnmbr = 1
	
  
func _on_tile_moved(tile: SlotTile, _nodePath) -> void:
	var reel := int(tile.position.x / tile_size.x)
	tiles_moved_per_reel[reel] += 1
	var reel_runs := current_runs(reel)
	if (tile.position.y > grid_pos[0][-1].y):
		tile.position.y = grid_pos[0][0].y
	var current_idx = total_runs - reel_runs
	if (current_idx < tiles_per_reel):
		var result_icon = symbolName[result.tiles[reel][0]] 
		var randomicon = _randomIcones()
		tile.set_icon(randomicon)
		tile.set_name(tile_name)
		tile.animate_icon_idle(randomicon)
	else:
		var randomicon = _randomIcones()
		tile.set_icon(randomicon)
		tile.set_name(tile_name)
	if (state != State.OFF && reel_runs != total_runs):
		tile.move_by(Vector2(0, tile_size.y))
	else: 
		tile.spin_down()
		if reel == reels - 1:
			_stop()

func current_runs(reel := 0) -> int:
  return int(ceil(float(tiles_moved_per_reel[reel]) / rows))

func _randomIcones() -> String:
	random.randomize()
	var num = random.randi_range(0, symbolName.size()-1)
	if num == 0:
		tile_name = symbolName[0]
	elif num == 1:
		tile_name = symbolName[1]
	elif num == 2:
		tile_name = symbolName[2]
	elif num == 3:
		tile_name = symbolName[3]
	elif num == 4:
		tile_name = symbolName[4]
	elif num == 5:
		tile_name = symbolName[5]
	elif num == 6:
		tile_name = symbolName[6]
	elif num == 7:
		tile_name = symbolName[7]
	elif num == 8:
		tile_name = symbolName[8] 
	elif num == 9:
		tile_name = symbolName[9] 
	return symbolName[num  %symbolName.size()]

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
	var tileAnim = SlotTile
	
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
	
	print("Result Masks: ", resultMasks);
	prizesToAnim = [];
	prizesToAnim = getPrizes(resultMasks);

func getPrizes(result_masks):
	var prizeInfo = [];
	for i in result_masks.size():
		for p in  prizeMasks.size():
			if (result_masks[i] & prizeMasks[p] == prizeMasks[p]):
				prizeInfo.push_back([i, p]) # First position -> Synbol IDX; Second Position -> Prize IDX
		for p in  prizeMasks2.size():
			if (result_masks[i] & prizeMasks2[p] == prizeMasks2[p]):
				prizeInfo.push_back([i, p]) # First position -> Synbol IDX; Second Position -> Prize IDX
				print("BLA BLA BLA BLA")

	print("Prize  Info: ", prizeInfo);
	return prizeInfo;

func animPrizes():
	var winTile
	var linha
	var coluna
	for p in prizesToAnim.size():
		for i in cells:
			var prizeID = symbolName[prizesToAnim[p][0]];
			if(prizeMasks[prizesToAnim[p][1]] & 1<<i):
				var _pcell = reels * tiles_per_reel - 1 - i
				print("ANIMAÇÃO: ",prizeID, "  CÉLULAS: ", _pcell);
					
				coluna = _pcell % 5;
				linha = int(floor(_pcell / 5));
				
				winTile = get_tile(coluna, linha)
				winTile.animate_icon(prizeID)
				givePoints(prizeID)

onready var totalPoints = 0

var smallWinToca = false
var mediumWinToca = false
var goodWinToca = false

func givePoints(prizeID):
	var pointsToGive
	if prizeID == "bunny":
		pointsToGive = 500
		goodWinToca = true
	elif prizeID == "lion":
		pass
	elif prizeID == "strongman":
		pointsToGive = 1000
		goodWinToca = true
	elif prizeID == "roulette":
		bonusLvl._entra()
	elif prizeID == "A":
		pointsToGive = 30
		smallWinToca = true
	elif prizeID == "K":
		pointsToGive =20
		smallWinToca = true
	elif prizeID == "Q":
		pointsToGive = 10
		smallWinToca = true
	elif prizeID == "J":
		pointsToGive = 5
		smallWinToca = true
	elif prizeID == "clown":
		pointsToGive = 5 * main.bet
	elif prizeID == "elephant":
		pointsToGive = 300

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_R:
			symbolName = ["roulette"];
		elif event.scancode == KEY_B:
			symbolName = ["bunny"];
		elif event.scancode == KEY_C:
			symbolName = ["clown"];
		elif event.scancode == KEY_S:
			symbolName = ["strongman"];
		elif event.scancode == KEY_L:
			symbolName = ["lion"];
		elif event.scancode == KEY_E:
			symbolName = ["elephant"];
