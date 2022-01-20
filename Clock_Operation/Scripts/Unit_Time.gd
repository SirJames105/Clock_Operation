extends Node

onready var main_clock = Clock

var time: int

func _physics_process(delta):
	time = main_clock.unit_time
