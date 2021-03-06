extends Node2D

const SlotTile := preload("res://scenes/Tile.tscn")

onready var main = load("res://Scripts/Main.gd").new()
onready var bonusLvl = load("res://Scripts/BonusLvl.gd").new()

const SPIN_UP_DISTANCE = 100.0
signal stopped

export(int,1,20) var reels := 5
export(int,1,20) var tiles_per_reel :=3 
export(float,0,10) var runtime := 1.7
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

const tiles := []
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
var prizesToAnim = [];

onready var reelSound = preload("res://sound/reels spin/Cyber Circus Reel Just Spin.mp3")

onready var reel1 = $Reel1
onready var reel2 = $reel2
onready var reel3 = $reel3
onready var reel4 = $reel4
onready var reel5 = $reel5


func _ready():
	setPrizeMasks();
	for col in reels:
		grid_pos.append([])
		tiles_moved_per_reel.append(0)
		for row in range(rows): 
			grid_pos[col].append(Vector2(col, row - 0.9 *extra_tiles) * tile_size) 
			_add_tile(col, row)

func setPrizeMasks():
	prizeMasks.push_back(0b000000000011111);
	prizeMasks.push_back(0b000001111100000);
	prizeMasks.push_back(0b111110000000000);
	prizeMasks.push_back(0b110000000000000);
	prizeMasks.push_back(0b000001100000000);
	prizeMasks.push_back(0b000000000011000);
	prizeMasks.push_back(0b100010101000100);
	prizeMasks.push_back(0b001000101010001);
	prizeMasks.push_back(0b110110010000000);
	prizeMasks.push_back(0b000000010011011);
	prizeMasks.push_back(0b000001000101110);
	prizeMasks.push_back(0b011101000100000);
	prizeMasks.push_back(0b010101010100000);


func _add_tile(col :int, row :int) -> void:
	tiles.append(SlotTile.instance())
	var tile := get_tile(col, row) 
	tile.get_node('Tween').connect("tween_completed", self, "_on_tile_moved", [], CONNECT_DEFERRED)
	tile.set_icon(_randomIcones())
	tile.set_size(tile_size)
	tile.set_name(tile_name)
	tile.position = grid_pos[col][row]
	tile.set_speed(speed_norm)
	add_child(tile)

func get_tile(col :int, row :int) -> SlotTile:
  return tiles[(col * rows) + row]

func start() -> void:
	var counter = 0
	if state == State.OFF: 
		state = State.ON 
		total_runs = expected_runs
		_get_result()
	for reel in reels:
		_spin_reel(reel)
		if counter == 0:
			$reel1.play()
			print("REEL 1 TOCA")
		elif counter == 1:
			$reel2.play()
			print("REEL 2 TOCA")
		elif counter == 2:
			$reel3.play()
			print("REEL 3 TOCA")
		elif counter == 3:
			$reel4.play()
			print("REEL 4 TOCA")
		elif counter == 4:
			$reel5.play()
			print("REEL 5 TOCA")
		if reel_delay > 0:
			   yield(get_tree().create_timer(reel_delay), "timeout")
		counter = counter+1
  
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
	var num = random.randi_range(0, 9)
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
	print("Prize  Info: ", prizeInfo);
	return prizeInfo;

func animPrizes():
	var oTile
	var estaReel
	var estaCol
	for p in prizesToAnim.size():
		for i in cells:
			var prizeID = symbolName[prizesToAnim[p][0]];
			if(prizeMasks[prizesToAnim[p][1]] & 1<<i):
				var _pcell = reels * tiles_per_reel - 1 - i
				print("ANIMA????O: ",prizeID, "  C??LULAS: ", _pcell);
				
#				if(_pcell == 0 or _pcell == 5 or _pcell == 10):
#					estaCol = 0
#				elif(_pcell == 1 or _pcell == 6 or _pcell == 11):
#					estaCol = 1
#				elif(_pcell == 2 or _pcell == 7 or _pcell == 12):
#					estaCol = 2
#				elif(_pcell == 3 or _pcell == 8 or _pcell == 13):
#					estaCol = 3
#				elif(_pcell == 4 or _pcell == 9 or _pcell == 14):
#					estaCol = 4
#
#				if (_pcell == 0 or _pcell == 1 or _pcell == 2 or _pcell == 3 or _pcell == 4):
#					estaReel = 0
#				if (_pcell == 5 or _pcell == 6 or _pcell == 7 or _pcell == 8 or _pcell == 9):
#					estaReel = 1
#				if (_pcell == 10 or _pcell == 11 or _pcell == 12 or _pcell == 13 or _pcell == 14):
#					estaReel = 2
					
#				oTile = get_tile(estaCol, estaReel)
				
				oTile.animate_icon(prizeID)

onready var totalPoints = 0

func givePoints(prizeID):
	var pointsToGive
	if prizeID == "bunny":
		pointsToGive = 1000
	elif prizeID == "lion":
		pointsToGive = 1500
	elif prizeID == "strongman":
		pointsToGive = 1600
	elif prizeID == "ticket":
		pointsToGive = 1700
	elif prizeID == "roulette":
		pointsToGive = 1800
#		Start Bonus Level
		bonusLvl._entra()
	elif prizeID == "A":
		pointsToGive = 2200
	elif prizeID == "K":
		pointsToGive = 2100
	elif prizeID == "Q":
		pointsToGive = 2000
	elif prizeID == "J":
		pointsToGive = 1900
	elif prizeID == "juggle":
		pointsToGive = 1550
	elif prizeID == "clown":
		pointsToGive = 1650
	elif prizeID == "elephant":
		pointsToGive = 1750
	
	totalPoints = totalPoints  + pointsToGive

