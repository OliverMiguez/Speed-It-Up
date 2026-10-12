extends "res://Scripts/Protagonista/MaquinaEstados/State.gd"

@export var idle_state: State
@export var caminar_state: State
@export var saltar_state: State

const TIEMPO_MAXIMO_PARED: float = 1.5 
var temporizador_pared: float = 0.0
var pared_actual_id: int = -1

func on_enter():
	print("AGARRAR")
	# Si viene cayendo demasiado rápido, no permitimos el re-agarre
	if father.velocity.y > 200.0:
		next_state = saltar_state
		return

	animation_player.play("AGARRAR")
	temporizador_pared = 0.0
	
	# CONGELAR COMPLETO
	father.velocity = Vector2.ZERO
	
	# Guardamos la normal de la pared
	var normal = father.get_wall_normal()
	if normal.x != 0:
		father.ultima_normal_pared = normal.x

func state_process(delta: float) -> void:
	# Si se activó el cooldown tras saltar o soltarse, salimos inmediatamente
	if father.cooldown_pared > 0:
		next_state = saltar_state
		return

	temporizador_pared += delta
	
	# Congelado durante el tiempo permitido
	if temporizador_pared < TIEMPO_MAXIMO_PARED:
		father.velocity = Vector2.ZERO
	else:
		# Al agotarse el tiempo, cae suavemente
		father.velocity.y += father.GRAVEDAD * delta

	var normal_pared = father.get_wall_normal()
	if normal_pared.x != 0:
		father.ultima_normal_pared = normal_pared.x
	else:
		normal_pared.x = father.ultima_normal_pared

	# SALTO DE REBOTE CON A / D
	var direccion_input := Input.get_axis("Izquierda", "Derecha")
	if direccion_input != 0 and sign(direccion_input) == sign(normal_pared.x):
		father.realizar_salto_pared_por_direccion(direccion_input)
		next_state = saltar_state
		return

	# TRANSICIONES A SUELO O AIRE
	if father.is_on_floor():
		if direccion_input != 0:
			next_state = caminar_state
		else:
			next_state = idle_state
	elif not father.is_on_wall():
		# Si se cae por la parte de abajo de un bloque flotante, le metemos un cooldown
		# de 0.5 segundos para que la gravedad lo aleje del bloque sin re-engancharse.
		father.cooldown_pared = 0.5
		next_state = saltar_state

func on_exit():
	pass
