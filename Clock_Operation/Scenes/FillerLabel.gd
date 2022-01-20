extends RichTextLabel
class_name FillerLabel

func _ready():
	self.text = ""

func _on_FillerTimer_timeout():
	self.text = ""
