extends VBoxContainer

onready var viewport =  $ViewportContainer/Viewport
onready var checkbutton = $CheckButton
onready var coverage = $Coverage
onready var time = $Time
onready var data_size = $DataSize

signal update_coverage()

var last_taken: float = 0
func _physics_process(delta):
	
	if not checkbutton.pressed:
		return
	
	if last_taken > 0.25:
		last_taken = 0
		
		_update_coverage()
	else:
		last_taken += delta

var data: Image
func _get_data():
	yield(get_tree(), 'idle_frame')
	data = viewport.get_texture().get_data()

func _update_coverage() -> void:
	var stopwatch = StopWatch.new()
	
	#yield(_get_data(), 'completed')
	
	#yield(get_tree(), 'idle_frame')
	var data = viewport.get_texture().get_data()
	
	var width = data.get_width()
	var height = data.get_height()
	
	data.lock()
	var pixel = data.get_pixel(0, 0)
	data.unlock()
	
	var _coverage_raw = pixel.r * 100.0
	var _coverage = round(_coverage_raw * 100) / 100.0
	
	stopwatch.stop()
	
	coverage.text = "%s%%" % _coverage
	time.text = "%dms" % stopwatch.milliseconds()
	data_size.text = "%dx%d" % [width, height]
	
	emit_signal("update_coverage")
