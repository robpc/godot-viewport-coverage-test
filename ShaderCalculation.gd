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
		viewport.render_target_update_mode = Viewport.UPDATE_ONCE
		
		call_deferred("_update_coverage")
	else:
		last_taken += delta

var data: Image
func _get_data():
	data = viewport.get_texture().get_data()
	viewport.render_target_update_mode = Viewport.UPDATE_ONCE

func _update_coverage() -> void:
	var stopwatch = StopWatch.new()

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
