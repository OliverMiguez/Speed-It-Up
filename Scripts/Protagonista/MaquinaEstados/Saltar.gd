extends "res://Scripts/Protagonista/MaquinaEstados/State.gd"

@export var idle_state: State
@export var caminar_state: State
@export var correr_state: State
@export var pared_state: State

# Rango de variación de tono para el salto
@export var pitch_min: float = 2
@export var pitch_max: float = 3.5

var tiempo_en_aire: float = 0.0

func on_enter():
	# Reproducir el audio de salto con pitch aleatorio
	var audio_salto = $"../../Salto"
	if audio_salto:
		audio_salto.pitch_scale = randf_range(pitch_min, pitch_max)
		audio_salto.play()

	print("SALTAR") 
	animation_player.play("SALTAR")
	tiempo_en_aire = 0.0
	
	# SOLO ejecutamos el salto impulsado si venimos del suelo o de pulsar la tecla de salto,
	# NO si venimos de desengancharnos de una pared (cooldown_pared > 0)
	if father.cooldown_pared <= 0:
		var esta_corriendo := Input.is_action_pressed("Shift")
		father.realizar_salto(esta_corriendo)

func state_process(delta: float) -> void:
	tiempo_en_aire += delta
	var esta_corriendo := Input.is_action_pressed("Shift")
	father.control_movimiento(esta_corriendo)
	
	# Transición a AGARRAR pared:
	# Requiere que lleve más de 0.15s en el aire Y que no estemos en cooldown de pared
	if tiempo_en_aire > 0.15 and father.cooldown_pared <= 0 and father.is_on_wall() and not father.is_on_floor():
		if "pared_state" in self and pared_state != null:
			next_state = pared_state
			return

	# Aterrizaje en suelo
	if tiempo_en_aire > 0.1 and father.is_on_floor():
		if Input.get_axis("Izquierda", "Derecha") != 0:
			if esta_corriendo and "correr_state" in self:
				next_state = correr_state
			else:
				next_state = caminar_state
		else:
			next_state = idle_state

func on_exit():
	pass
