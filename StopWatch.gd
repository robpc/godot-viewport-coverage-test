class_name StopWatch

var _start: int
var _stop: int

func _init():
	_start = Time.get_ticks_msec()

func stop() -> void:
	_stop = Time.get_ticks_msec()

func milliseconds() -> int:
	if not _stop:
		return 0
	
	return _stop - _start

func seconds() -> float:
	return milliseconds() / 1000.0
