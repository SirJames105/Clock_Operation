extends RichTextLabel
class_name Time

onready var clock: Timer = get_parent().get_parent()

func _physics_process(_delta):
	self.text = str(clock.year) + ":" + str(clock.day) + ":" + str(clock.hour) + ":" + str(clock.minute) + ":" + str(clock.second)
