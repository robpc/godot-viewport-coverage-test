class_name StopWatch

var _start: int
var _stop: int

func _init() -> void:
	_start = OS.get_ticks_msec()

func stop() -> void:
	_stop = OS.get_ticks_msec()

func milliseconds() -> int:
	if not _stop:
		return 0
	
	return _stop - _start

func seconds() -> float:
	return milliseconds() / 1000.0
