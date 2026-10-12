extends "res://Scripts/Protagonista/MaquinaEstados/State.gd"

@export var caminar_state:State
@export var saltar_state:State

func on_enter():
	print("IDLE")
	animation_player.play("IDLE")

func state_process(_delta:float) -> void:

	father.velocity.x = 0
	
	if Input.is_action_just_pressed("Saltar") and father.is_on_floor():
		next_state = saltar_state
	elif Input.get_axis("Izquierda", "Derecha") != 0:
		next_state = caminar_state

func on_exit():
	#print("State Exit: ", self.name)
	pass
