extends "res://Scripts/Protagonista/MaquinaEstados/State.gd"

@export var idle_state: State
@export var saltar_state: State
@export var caminar_state: State

# Rango de variación de tono (al subirlo también reproduce el audio más rápido)
@export var pitch_min: float = 2
@export var pitch_max: float = 3.5

# Tiempo en segundos entre cada pisada (cuanto menor sea el número, más rápido suena)
@export var cadencia_pasos: float = 0.17 # ~0.17s encaja perfecto con ritmos rápidos de 175 BPM

var temporizador_pasos: float = 0.0

func on_enter():
	print("CORRER")
	if animation_player:
		animation_player.play("CORRER")
	
	# Reiniciamos el temporizador y suena el primer paso
	temporizador_pasos = 0.0
	reproducir_paso()

func state_process(delta: float) -> void:
	father.control_movimiento(true) # corriendo
	
	# Control de frecuencia de las pisadas
	temporizador_pasos += delta
	if temporizador_pasos >= cadencia_pasos:
		temporizador_pasos = 0.0
		reproducir_paso()

	if Input.is_action_just_pressed("Saltar"):
		next_state = saltar_state
		return
	elif not Input.is_action_pressed("Shift") and Input.get_axis("Derecha", "Izquierda") != 0:
		next_state = caminar_state
		return
	elif Input.get_axis("Izquierda", "Derecha") == 0:
		next_state = idle_state
		return

func on_exit():
	# Detener el sonido al cambiar de estado
	if father and father.has_node("AudioPasos"):
		var audio = father.get_node("AudioPasos") as AudioStreamPlayer
		audio.stop()

func reproducir_paso() -> void:
	if father and father.has_node("AudioPasos"):
		var audio = father.get_node("AudioPasos") as AudioStreamPlayer
		audio.pitch_scale = randf_range(pitch_min, pitch_max)
		audio.play()
