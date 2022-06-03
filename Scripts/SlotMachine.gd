extends Node2D

const SlotTile := preload("res://scenes/Tile.tscn")
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

var col1Mid
var col2Mid 
var col3Mid 
var col4Mid 
var col5Mid 

var col1Mid_name
var col2Mid_name
var col3Mid_name
var col4Mid_name
var col5Mid_name

export(Array, String) var symbolName := ["bunny", "lion","strongman", 
"ticket", "roulette","A", "J", "K", "Q", "juggle", "clown", "elephant"];

var bunny = 0
var clown= 0
var elephant= 0
var j= 0
var k= 0
var lion= 0
var malabare= 0
var strongman= 0
var q= 0

var reel1

var prizeNb = 3
var prizeMasks = [];
var prizesToAnim = [];

onready var reelSound1 = preload("res://sound/reels spin/Cyber Circus Reel Just Spin.mp3")
onready var reelSound2 = preload("res://sound/reels spin/Cyber Circus Reel Reel Set.mp3")

onready var reel1Audio = $reel1
onready var reel2Audio = $reel2
onready var reel3Audio = $reel3
onready var reel4Audio = $reel4
onready var reel5Audio = $reel5

var reelsAudio = [reel1Audio, reel2Audio, reel3Audio, reel4Audio, reel5Audio]

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
 if state == State.OFF: 
		state = State.ON 
		total_runs = expected_runs
		_get_result()
	for reel in reels:
		_spin_reel(reel)
#		reelsAudio[reel].stream = reelSound1
#		reelsAudio[reel].play()
		if reel_delay > 0:
			   yield(get_tree().create_timer(reel_delay), "timeout")
  
func stop():
	state = State.STOPPED
	runs_stopped = current_runs()
	total_runs = runs_stopped + tiles_per_reel + 1
#	print("STOOOOOOOOPPPPP")
	

func _stop() -> void:
	for reel in reels:
		tiles_moved_per_reel[reel] = 0
		state = State.OFF
		emit_signal("stopped")
	if state == State.OFF:
		idk()
	buildResultMasks();
	animPrizes();

#0.00164684

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

func idk():
	col1Mid = get_tile(0,3)
	col2Mid = get_tile(1,3)
	col3Mid = get_tile(2,3)
	col4Mid = get_tile(3,3)
	col5Mid = get_tile(4,3)
	
	col1Mid_name = col1Mid.tileName
	col2Mid_name = col2Mid.tileName
	col3Mid_name = col3Mid.tileName
	col4Mid_name = col4Mid.tileName
	col5Mid_name = col5Mid.tileName

func current_runs(reel := 0) -> int:
  return int(ceil(float(tiles_moved_per_reel[reel]) / rows))

func _randomIcones() -> String:
	random.randomize()
	var num = random.randi_range(0, 11)
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
	elif num == 10:
		tile_name = symbolName[10] 
	elif num == 11:
		tile_name = symbolName[11] 
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
	var firstReel
	var scndReel
	var thirdReel
	var forthReel
	var fifthReel
	
	var oTile
	var estaReel
	var estaCol
	for p in prizesToAnim.size():
		for i in cells:
			var prizeID = symbolName[prizesToAnim[p][0]];
			if(prizeMasks[prizesToAnim[p][1]] & 1<<i):
				var _pcell = reels * tiles_per_reel - 1 - i
				print("ANIMAÇÃO: ",prizeID, "  CÉLULAS: ", _pcell);
				
				if(_pcell == 0 or _pcell == 5 or _pcell == 10):
					estaReel = 0
				elif(_pcell == 1 or _pcell == 6 or _pcell == 11):
					estaReel = 1
				elif(_pcell == 2 or _pcell == 7 or _pcell == 12):
					estaReel = 2
				elif(_pcell == 3 or _pcell == 8 or _pcell == 13):
					estaReel = 3
				elif(_pcell == 4 or _pcell == 9 or _pcell == 14):
					estaReel = 4
					
				if (_pcell == 0 or _pcell == 1 or _pcell == 2 or _pcell == 3 or _pcell == 4):
					estaCol = 0
				if (_pcell == 5 or _pcell == 6 or _pcell == 7 or _pcell == 8 or _pcell == 9):
					estaCol = 1
				if (_pcell == 10 or _pcell == 11 or _pcell == 12 or _pcell == 13 or _pcell == 14):
					estaCol = 2
					
					
				oTile = get_tile(estaCol, estaReel)
				oTile.animate_icon(prizeID)
				
