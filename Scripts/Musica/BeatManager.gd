extends AudioStreamPlayer

# 140 BPM -> Pulso cada 4 beats (1.714 segundos)
const BPM: float = 140.0
const SEGUNDOS_POR_BEAT: float = (60.0 / BPM) * 4.0

@export var canvas_modulate: CanvasModulate
@export var camara: Camera2D

# Colores de modulación
const COLOR_BASE: Color = Color(1.0, 1.0, 1.0, 1.0) 
const COLOR_BEAT: Color = Color("1e69c1")

var timer_beat: Timer
# Alterna la dirección del balanceo (-1 o 1)
var direccion_rotacion: int = -1

func _ready() -> void:
	timer_beat = Timer.new()
	timer_beat.wait_time = SEGUNDOS_POR_BEAT
	timer_beat.autostart = false
	timer_beat.one_shot = false
	timer_beat.timeout.connect(_on_golpe_beat)
	add_child(timer_beat)

# Se llama cuando acaba la cuenta atrás ("GO!")
func iniciar_con_ritmo() -> void:
	play()
	_on_golpe_beat()
	timer_beat.start()

func _on_golpe_beat() -> void:
	if not playing:
		timer_beat.stop()
		return
		
	efecto_flash_canvas()
	efecto_zoom_camara_sutil()

func efecto_flash_canvas() -> void:
	if not canvas_modulate:
		return
		
	var tween = create_tween()
	canvas_modulate.color = COLOR_BEAT
	
	tween.tween_property(canvas_modulate, "color", COLOR_BASE, SEGUNDOS_POR_BEAT * 0.85)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

func efecto_zoom_camara_sutil() -> void:
	if not camara:
		return
		
	# 1. CÁLCULO DE ZOOM
	var zoom_actual = camara.zoom
	var multiplicador_impulso: float = 1.2
	
	# Ajuste dinámico según si corre (x2) o camina (x3)
	if zoom_actual.x <= 2.5:
		multiplicador_impulso = 1.3
	
	var zoom_impulso = zoom_actual * multiplicador_impulso
	
	# 2. CÁLCULO DE INCLINACIÓN (0.8 grados hacia un lado u otro)
	var angulo_objetivo: float = deg_to_rad(0.8 * direccion_rotacion)
	direccion_rotacion *= -1 # Cambia el sentido para el siguiente golpe
	
	# 3. ANIMACIÓN PARALELA (Zoom + Rotación)
	var tween = create_tween().set_parallel(true)
	
	# Animación de Zoom
	camara.zoom = zoom_impulso
	tween.tween_property(camara, "zoom", zoom_actual, 0.2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	# Animación de Inclinación: se inclina al instante y vuelve suave a 0 grados
	camara.rotation = angulo_objetivo
	tween.tween_property(camara, "rotation", 0.0, 0.25)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
