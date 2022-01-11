extends Timer
class_name Clock

enum {ADD, SUBTRACT}
var change_state = ADD

var second: int
var minute: int
var hour: int
var day: int
var year: int

onready var undo_Timer: Timer = $Undo_Timer
onready var timeChangedTimer: Timer = $Control/TimeChangedLabel/TimeChangedTimer
onready var timeChangedLabel: RichTextLabel = $Control/TimeChangedLabel


signal undo_text_start

func _ready():
	self.load_time()
	print("year:day:hour:minute:second")
	print_time()

func load_time():
	var openFile: File = File.new()
	if not openFile.file_exists("user://NDTimerFile.txt"):
		self.use_default_time()
	var _Error_value : int = openFile.open("user://NDTimerFile.txt", File.READ)
	if openFile.get_len() <= 0:
		self.use_default_time()
	while openFile.get_position() < openFile.get_len():
		var data: Dictionary = parse_json(openFile.get_line())
		second = data.get("second")
		minute = data.get("minute")
		hour = data.get("hour")
		day = data.get("day")
		year = data.get("year")
		yield(get_tree(), "idle_frame")
	openFile.close()

func use_default_time():
	second = 0
	minute = 0
	hour = 0
	day = 0
	year = 0

func _on_Button_pressed():
	if self.is_stopped():
		start()
		print("time resumed")
		timeChangedTimer.start()
		timeChangedLabel.text = "time resumed"
	else:
		stop()
		print("time stopped")
		timeChangedTimer.start()
		timeChangedLabel.text = "time stopped"

func _on_DN_Cycle_timeout():
	second += 1
	time_conversion()
	print_time()

func print_time():
	print(year, ":", day, ":", hour, ":", minute, ":", second)

func _physics_process(_delta):
	time_conversion()
	solve_neg_time()
	change_time()

func time_conversion():
	if second >= 60: # Seconds to minutes
		second -= 60
		minute += 1
	if minute >= 60: # minutes to hours
		minute -= 60
		hour += 1
	if hour >= 24: # hours to days
		hour -= 24
		day += 1
	if day >= 365: # days to years
		day -= 365
		year += 1

func solve_neg_time():
	if second < 0 and (minute > 0 or hour > 0 or day > 0 or year > 0): # neg seconds
		minute -= 1
		second += 60
	if minute < 0: # neg minutes
		hour -= 1
		minute += 60
	if hour < 0: # neg hours
		day -= 1
		hour += 24
	if day < 0 and year > 0: #neg days
		year -= 1
		day += 365

func change_time():
	if Input.is_action_just_pressed("add"):
		change_state = ADD
		print("setting changed to add")
		timeChangedTimer.start()
		timeChangedLabel.text = "setting changed to add"
	if Input.is_action_just_pressed("subtract"):
		change_state = SUBTRACT
		print("setting changed to subtract")
		timeChangedTimer.start()
		timeChangedLabel.text = "setting changed to subtract"
	if Input.is_action_just_pressed("reset"):
		if undo_Timer.time_left == 0:
			_on_ResetTimeButton_pressed()
		else:
			print("time already resetted")
			timeChangedTimer.start()
			timeChangedLabel.text = "time already resetted"
	match change_state:
		ADD:
			add_time()
		SUBTRACT:
			subtract_time()

func add_time():
	if Input.is_action_just_pressed("second"):
		_on_SAButton_pressed()
	if Input.is_action_just_pressed("minute"):
		_on_MAButton_pressed()
	if Input.is_action_just_pressed("hour"):
		_on_HAButton_pressed()
	if Input.is_action_just_pressed("day"):
		_on_DAButton_pressed()
	if Input.is_action_just_pressed("year"):
		_on_YAButton_pressed()

func _on_SAButton_pressed():
	second += 1
	print("second added")
	timeChangedTimer.start()
	timeChangedLabel.text = "second added"
func _on_MAButton_pressed():
	minute += 1
	print("minute added")
	timeChangedTimer.start()
	timeChangedLabel.text = "minute added"
func _on_HAButton_pressed():
	hour += 1
	print("hour added")
	timeChangedTimer.start()
	timeChangedLabel.text = "hour added"
func _on_DAButton_pressed():
	day += 1
	print("day added")
	timeChangedTimer.start()
	timeChangedLabel.text = "day added"
func _on_YAButton_pressed():
	year += 1
	print("year added")
	timeChangedTimer.start()
	timeChangedLabel.text = "year added"

func subtract_time():
	if Input.is_action_just_pressed("second"):
		_on_SSButton_pressed()
	if Input.is_action_just_pressed("minute"):
		_on_MSButton_pressed()
	if Input.is_action_just_pressed("hour"):
		_on_HSButton_pressed()
	if Input.is_action_just_pressed("day"):
		_on_DSButton_pressed()
	if Input.is_action_just_pressed("year"):
		_on_YSButton_pressed()

func _on_SSButton_pressed():
	if second > 0 or minute > 0 or hour > 0 or day > 0 or year > 0:
		second -= 1
		print("second subtracted")
		timeChangedTimer.start()
		timeChangedLabel.text = "second subtracted"
	else:
		print("no time left")
		timeChangedTimer.start()
		timeChangedLabel.text = "no time left"

func _on_MSButton_pressed():
	if minute > 0 or hour > 0 or day > 0 or year > 0:
		minute -= 1
		print("minute subtracted")
		timeChangedTimer.start()
		timeChangedLabel.text = "minute subtracted"
	else:
		print("no minutes to subtract")
		timeChangedTimer.start()
		timeChangedLabel.text = "no minutes to subtract"

func _on_HSButton_pressed():
	if hour > 0 or day > 0 or year > 0:
		hour -= 1
		print("hour subtracted")
		timeChangedTimer.start()
		timeChangedLabel.text = "hour subtracted"
	else:
		print("no hours to subtract")
		timeChangedTimer.start()
		timeChangedLabel.text = "no hours to subtract"

func _on_DSButton_pressed():
	if day > 0 or year > 0:
		day -= 1
		print("day subtracted")
		timeChangedTimer.start()
		timeChangedLabel.text = "day subtracted"
	else:
		print("no days to subtract")
		timeChangedTimer.start()
		timeChangedLabel.text = "no days to subtract"

func _on_YSButton_pressed():
	if year > 0:
		year -= 1
		print("year subtracted")
		timeChangedTimer.start()
		timeChangedLabel.text = "year subtracted"
	else:
		print("no years to subtract")
		timeChangedTimer.start()
		timeChangedLabel.text = "no years to subtract"

func _on_ResetTimeButton_pressed():
	var resetButton: Button = $Control/ResetTimeButton
	while resetButton.state == "don't":
		yield(get_tree(), "idle_frame")
		if undo_Timer.time_left == 0:
			reset_time()
		else:
			print("time already resetted")
			timeChangedTimer.start()
			timeChangedLabel.text = "time already resetted"

func reset_time():
	var time: PoolIntArray = [year, day, hour, minute, second]
	var resetButton: Button = $Control/ResetTimeButton
	use_default_time()
	undo_Timer.start()
	print("time resetted")
	timeChangedTimer.start()
	timeChangedLabel.text = "time resetted"
	emit_signal("undo_text_start")
	while undo_Timer.time_left != 0:
		if Input.is_action_just_pressed("undo") or resetButton.state == "don't":
			second = time[4]
			minute = time[3]
			hour = time[2]
			day = time[1]
			year = time[0]
			print("time reverted")
			timeChangedTimer.start()
			timeChangedLabel.text = "time reverted"
			undo_Timer.stop()
			resetButton.text = "Reset Time"
			break
		yield(get_tree(), "idle_frame")

func _notification(arg):
	if arg == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		self.save_time()
		get_tree().quit() 

func save_time():
	var saveFile: File = File.new()
	var _Error_value : int = saveFile.open("user://NDTimerFile.txt", File.WRITE)
	var timeData: Dictionary = {"second": second, "minute": minute, "hour": hour, "day": day, "year": year}
	saveFile.store_line(to_json(timeData))
	saveFile.close()

