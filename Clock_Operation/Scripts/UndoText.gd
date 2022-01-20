extends RichTextLabel
class_name UndoText

onready var undo_Timer: Timer = get_parent().get_parent().get_parent().get_node("Undo_Timer")

func _ready():
	self.text = ""

func _on_Main_Clock_undo_text_start():
	while undo_Timer.time_left != 0:
		self.text = str(undo_Timer.time_left)
		yield(get_tree(), "idle_frame")
	self.text = ""
