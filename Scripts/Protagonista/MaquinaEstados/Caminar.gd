extends "res://Scripts/Protagonista/MaquinaEstados/State.gd"

@export var idle_state:State
@export var saltar_state:State
@export var correr_state:State

func on_enter():
	print("CAMINAR")
	animation_player.play("ANDAR")

func state_process(_delta:float) -> void:
	father.control_movimiento(false) # andando
	
	if Input.is_action_just_pressed("Saltar"):
		next_state = saltar_state
		return
	elif Input.is_action_pressed("Shift") and Input.get_axis("Izquierda", "Derecha") != 0:
		next_state = correr_state
		return
	elif Input.get_axis("Izquierda", "Derecha") == 0:
		next_state = idle_state

func on_exit():
	#print("State Exit: ", self.name)
	pass
