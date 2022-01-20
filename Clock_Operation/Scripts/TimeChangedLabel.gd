extends RichTextLabel
class_name TimeChangedLabel

func _ready():
	self.text = ""

func _on_TimeChangedTimer_timeout():
	self.text = ""
