extends "res://Scripts/Protagonista/MaquinaEstados/State.gd"

@export var idle_state: State
@export var caminar_state: State
@export var correr_state: State
@export var saltar_state: State

# Desfase opcional si quieres ajustar el tamaño de la colisión al agacharte
var colision_original_height: float = 0.0

func on_enter():
	print("SLIDER")
	if animation_player:
		animation_player.play("SLIDER")

func state_process(_delta: float) -> void:
	# Mantenemos el movimiento del jugador (corriendo o andando según la velocidad)
	father.control_movimiento(true)
	
	# 1. Transición a SALTO
	if Input.is_action_just_pressed("Saltar"):
		next_state = saltar_state
		return
	
	# 2. Si se deja de pulsar la tecla de deslizarse/abajo
	if not Input.is_action_pressed("Abajo") and not Input.is_action_pressed("Slide"):
		var direccion = Input.get_axis("Izquierda", "Derecha")
		var corriendo = Input.is_action_pressed("Shift") or Input.is_action_pressed("Correr")
		
		if direccion != 0:
			if corriendo and correr_state:
				next_state = correr_state
			elif caminar_state:
				next_state = caminar_state
		else:
			if idle_state:
				next_state = idle_state
		return

	# 3. Si el jugador se detiene completamente
	if Input.get_axis("Izquierda", "Derecha") == 0:
		next_state = idle_state

func on_exit():
	pass
