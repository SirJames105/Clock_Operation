extends RichTextLabel
class_name TimeDisplay

enum TIME_FORMAT {UNIT, DIGITAL, CALENDAR}
var time_format = TIME_FORMAT.DIGITAL

var second: String
var minute: String
var hour: String
var day: String
var year: String

onready var clock: Timer = get_parent().get_parent()
onready var timeChangedTimer: Timer = get_parent().get_node("TimeChangedLabel/TimeChangedTimer")
onready var timeChangedLabel: RichTextLabel = get_parent().get_node("TimeChangedLabel")

func _physics_process(_delta):
	match time_format:
		TIME_FORMAT.UNIT:
			display_unit_time()
		TIME_FORMAT.DIGITAL:
			display_digital_time()
		TIME_FORMAT.CALENDAR:
			display_calendar_time()

func _on_TimeFormatButton_pressed():
	match time_format:
		TIME_FORMAT.UNIT:
			time_format = TIME_FORMAT.DIGITAL
			configure_time_changed_label()
		TIME_FORMAT.DIGITAL:
			time_format = TIME_FORMAT.CALENDAR
			margin_right = 924
			margin_left = 100
			margin_top = 280
			self.get("custom_fonts/normal_font").size = 50
			configure_time_changed_label()
		TIME_FORMAT.CALENDAR:
			time_format = TIME_FORMAT.UNIT
			margin_right = 750
			margin_left = 250
			margin_top = 265
			self.get("custom_fonts/normal_font").size = 75
			configure_time_changed_label()

func configure_time_changed_label():
	timeChangedTimer.start()
	timeChangedLabel.text = "format changed"

func display_unit_time():
	self.text = str(clock.unit_time)

func display_digital_time():
	add_zero_to_first_three()
	day = "0" + str(clock.day) if clock.day < 10 else clock.day
	year = "0" + str(clock.year) if clock.year < 10 else clock.year
	self.text = (str(year) + ":" + 
	str(day) + ":" + str(hour) + ":" + 
	str(minute) + ":" + str(second))

func add_zero_to_first_three():
	second = "0" + str(clock.second) if clock.second < 10 else clock.second
	minute = "0" + str(clock.minute) if clock.minute < 10 else clock.minute
	hour = "0" + str(clock.hour) if clock.hour < 10 else clock.hour

func display_calendar_time():
	var month: String
	var day_of_the_month: int
	var day_of_the_week: String
	if clock.day < 181:
		if clock.day < 31:
			month = "January"
			day_of_the_month = clock.day + 1
		elif clock.day < 59:
			month = "February"
			day_of_the_month = clock.day - 30
		elif clock.day < 90:
			month = "March"
			day_of_the_month = clock.day - 58
		elif clock.day < 120:
			month = "April"
			day_of_the_month = clock.day - 89
		elif clock.day < 151:
			month = "May"
			day_of_the_month = clock.day - 119
		else:
			month = "June" 
			day_of_the_month = clock.day - 150
	else:
		if clock.day < 212:
			month = "July" 
			day_of_the_month = clock.day - 180
		elif clock.day < 243:
			month = "August"
			day_of_the_month = clock.day - 211
		elif clock.day < 273:
			month = "September" 
			day_of_the_month = clock.day - 242
		elif clock.day < 304:
			month = "October" 
			day_of_the_month = clock.day - 272
		elif clock.day < 334:
			month = "November" 
			day_of_the_month = clock.day - 303
		else:
			month = "December" 
			day_of_the_month = clock.day - 333
	
	match (clock.day + (clock.year * 365)) % 7:
		0:
			day_of_the_week = "Sunday"
		1:
			day_of_the_week = "Monday"
		2:
			day_of_the_week = "Tuesday"
		3:
			day_of_the_week = "Wednesday"
		4:
			day_of_the_week = "Thursday"
		5:
			day_of_the_week = "Friday"
		6:
			day_of_the_week = "Saturday"
		_:
			day_of_the_week = "Noday"
	
	add_zero_to_first_three()
	self.text = (str(day_of_the_week) + ", " + str(month) + " " 
	+ str(day_of_the_month) + ", year " + str(clock.year) + 
	", " + str(hour) + ":" + str(minute) + ":" + str(second))

