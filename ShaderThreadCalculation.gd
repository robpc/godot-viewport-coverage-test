extends VBoxContainer

@onready var viewport =  $ViewportContainer/Viewport
@onready var checkbutton = $CheckButton
@onready var coverage = $Coverage
@onready var time = $Time
@onready var data_size = $DataSize

signal update_coverage()

var thread
var _should_stop_thread: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	thread.start(self, "_run_thread")

func _run_thread(_userdata):
	while not _should_stop_thread:
		if checkbutton.pressed:
			_update_coverage()
		
		OS.delay_msec(500)

func _exit_tree():
	_should_stop_thread = true
	thread.wait_to_finish()

func _update_coverage() -> void:
	var stopwatch = StopWatch.new()

	var data = viewport.get_texture().get_image()
	
	var width = data.get_width()
	var height = data.get_height()
	
	var pixel = data.get_pixel(0, 1)
	
	var _coverage_raw = pixel.r * 100.0
	var _coverage = round(_coverage_raw * 100) / 100.0
	
	stopwatch.stop()
	
	coverage.text = "%s%%" % _coverage
	time.text = "%dms" % stopwatch.milliseconds()
	data_size.text = "%dx%d" % [width, height]
	
	emit_signal("update_coverage")
