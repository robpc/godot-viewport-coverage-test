extends VBoxContainer

@onready var viewport = $"../Map/Viewport"
@onready var checkbutton = $CheckButton
@onready var coverage = $Coverage
@onready var time = $Time
@onready var data_size = $DataSize

var last_taken: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	pass
	
	if not checkbutton.pressed:
		return
		
	if last_taken > 0.5:
		last_taken = 0
		_update_coverage()
		
	else:
		last_taken += delta

func _update_coverage():
	var stopwatch = StopWatch.new()
	
	var data = viewport.get_texture().get_image()
	var width = data.get_width()
	var height = data.get_height()

	var total: float = 0.0
	var complete: float = 0.0
	
	for x in range(width):
		for y in range(height):
			var pixel = data.get_pixel(x, y)
			if pixel != Color.BLACK: 
				total += 1
				if pixel != Color.WHITE:
					complete += 1
	
	var _coverage_raw = complete / total * 100.0
	var _coverage = round(_coverage_raw * 100) / 100.0
	
	stopwatch.stop()
	
	coverage.text = "%s%%" % _coverage
	time.text = "%dms" % stopwatch.milliseconds()
	data_size.text = "%dx%d" % [width, height]
