extends Button
class_name ResetTimeButton

var state: String = "don't"

onready var undo_Timer : Timer = get_parent().get_parent().get_node("Undo_Timer")

func _physics_process(_delta):
	if Input.is_action_just_pressed("reset") or (Input.is_action_just_pressed("undo") and undo_Timer.time_left != 0):
		_on_ResetTimeButton_pressed()
	elif Input.is_action_just_pressed("undo") and undo_Timer.time_left == 0:
		print("can't undo time before resetting")

func _on_ResetTimeButton_pressed():
	if self.text == "Reset Time":
		state = "go"
		self.text = "Undo Time"
	else:
		state = "don't"
		self.text = "Reset Time"

func _on_Undo_Timer_timeout():
	self.text = "Reset Time"
	state = "don't"

