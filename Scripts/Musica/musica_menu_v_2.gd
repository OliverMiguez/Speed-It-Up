extends AudioStreamPlayer

# Configuración de Tempo (175 BPM)
const BPM: float = 175.0
const SEGUNDOS_POR_BEAT_BASE: float = 60.0 / BPM

# Duraciones de los pulsos
const TIEMPO_PULSO_NORMAL: float = SEGUNDOS_POR_BEAT_BASE * 4.0   # Módulos lentos (cada 4 beats)
const TIEMPO_PULSO_RAPIDO: float = SEGUNDOS_POR_BEAT_BASE * 2.0   # Módulos rápidos (cada 2 beats)

# Puntos de cambio en segundos (1m04s = 64 segundos)
const TIEMPO_DROP_1: float = 24.0
const TIEMPO_BREAKDOWN: float = 40.0
const TIEMPO_DROP_2: float = 64.0

# Referencias dinámicas recibidas desde la escena activa (Reemplazan a los @export)
var canvas_modulate: CanvasModulate = null
var camara: Camera2D = null

# Colores de modulación
const COLOR_BASE: Color = Color(1.0, 1.0, 1.0, 1.0) 
const COLOR_BEAT: Color = Color("1e69c1")

var timer_beat: Timer
var direccion_rotacion: int = 1
var estado_ritmo_actual: String = ""

# Guardamos referencias a los Tweens para poder cancelarlos si están activos
var tween_canvas: Tween
var tween_camara: Tween

func _ready() -> void:
	timer_beat = Timer.new()
	timer_beat.wait_time = TIEMPO_PULSO_NORMAL
	timer_beat.autostart = false
	timer_beat.one_shot = false
	timer_beat.timeout.connect(_on_golpe_beat)
	add_child(timer_beat)

# Función imprescindible para asignarle la cámara y canvas de la escena actual
func registrar_nodos(p_camara: Camera2D = null, p_canvas: CanvasModulate = null) -> void:
	# Matamos tweens antiguos por seguridad antes de cambiar referencias
	if tween_canvas and tween_canvas.is_running():
		tween_canvas.kill()
	if tween_camara and tween_camara.is_running():
		tween_camara.kill()
		
	camara = p_camara
	canvas_modulate = p_canvas
	
	if is_instance_valid(canvas_modulate):
		canvas_modulate.color = COLOR_BASE

func _process(_delta: float) -> void:
	if playing:
		var pos = get_playback_position()
		
		# Determinar la fase visual según el segundo actual
		if pos >= TIEMPO_DROP_2:
			if estado_ritmo_actual != "DROP_2":
				cambiar_frecuencia_pulso(TIEMPO_PULSO_RAPIDO, "DROP_2")
				
		elif pos >= TIEMPO_BREAKDOWN:
			if estado_ritmo_actual != "BREAKDOWN":
				cambiar_frecuencia_pulso(TIEMPO_PULSO_NORMAL, "BREAKDOWN")
				
		elif pos >= TIEMPO_DROP_1:
			if estado_ritmo_actual != "DROP_1":
				cambiar_frecuencia_pulso(TIEMPO_PULSO_RAPIDO, "DROP_1")
				
		else:
			if estado_ritmo_actual != "INTRO":
				cambiar_frecuencia_pulso(TIEMPO_PULSO_NORMAL, "INTRO")

# Se llama cuando inicia el menú o acaba la cuenta atrás
func iniciar_con_ritmo() -> void:
	# Si ya está sonando, no reiniciamos la canción para mantener la fluidez
	if not playing:
		play()
		estado_ritmo_actual = "INTRO"
		timer_beat.wait_time = TIEMPO_PULSO_NORMAL
		_on_golpe_beat()
		timer_beat.start()

func detener_musica() -> void:
	if playing:
		stop()
	if timer_beat:
		timer_beat.stop()
	camara = null
	canvas_modulate = null
	estado_ritmo_actual = ""

func cambiar_frecuencia_pulso(nuevo_intervalo: float, nuevo_estado: String) -> void:
	estado_ritmo_actual = nuevo_estado
	
	# 1. Cortamos cualquier efecto o golpe pendiente del bloque anterior
	if tween_canvas and tween_canvas.is_running():
		tween_canvas.kill()
	if tween_camara and tween_camara.is_running():
		tween_camara.kill()
		
	# Restablecemos estado visual base de forma segura
	if is_instance_valid(canvas_modulate):
		canvas_modulate.color = COLOR_BASE
	if is_instance_valid(camara):
		camara.rotation = 0.0
	
	# 2. Reiniciamos el timer con la nueva velocidad y lanzamos el golpe limpio
	timer_beat.stop()
	timer_beat.wait_time = nuevo_intervalo
	_on_golpe_beat()
	timer_beat.start()

func _on_golpe_beat() -> void:
	if not playing:
		timer_beat.stop()
		return
		
	efecto_flash_canvas()
	efecto_zoom_camara_sutil()

func efecto_flash_canvas() -> void:
	if not is_instance_valid(canvas_modulate):
		return
		
	if tween_canvas and tween_canvas.is_running():
		tween_canvas.kill()
		
	tween_canvas = create_tween()
	canvas_modulate.color = COLOR_BEAT
	
	tween_canvas.tween_property(canvas_modulate, "color", COLOR_BASE, timer_beat.wait_time * 0.85)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

func efecto_zoom_camara_sutil() -> void:
	if not is_instance_valid(camara):
		return
		
	if tween_camara and tween_camara.is_running():
		tween_camara.kill()
		
	var zoom_actual = camara.zoom
	var multiplicador_impulso: float = 1.2
	
	if zoom_actual.x <= 2.5:
		multiplicador_impulso = 1.3
	
	var zoom_impulso = zoom_actual * multiplicador_impulso
	var angulo_objetivo: float = deg_to_rad(0.8 * direccion_rotacion)
	direccion_rotacion *= -1
	
	tween_camara = create_tween().set_parallel(true)
	
	camara.zoom = zoom_impulso
	tween_camara.tween_property(camara, "zoom", zoom_actual, 0.12)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	camara.rotation = angulo_objetivo
	tween_camara.tween_property(camara, "rotation", 0.0, 0.15)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)


func _on_finished() -> void:
	$".".play()
