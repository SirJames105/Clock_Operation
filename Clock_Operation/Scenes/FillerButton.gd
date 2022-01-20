extends Button
class_name FillerButton

var times_pressed: int = 0

onready var fillerTimer: Timer = $FillerTimer
onready var fillerLabel: RichTextLabel = get_parent().get_node("FillerLabel")

func _on_FillerButton_pressed():
	times_pressed += 1
	if times_pressed < 25:
		fillerTimer.start()
		fillerLabel.text = "This button does nothing."
	elif times_pressed < 50:
		fillerTimer.start()
		fillerLabel.text = "Please stop pressing this button."
	elif times_pressed < 75:
		fillerTimer.start()
		fillerLabel.text = "STOP!!!!"
	else:
		fillerTimer.paused = true
		fillerLabel.text = "That's it. No filler button for you."
		self.hide()
		fillerLabel.margin_right = 1024
		fillerLabel.margin_left = 524
