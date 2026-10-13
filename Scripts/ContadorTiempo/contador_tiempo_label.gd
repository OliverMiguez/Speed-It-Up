extends HBoxContainer
class_name ContadorTiempoImagenes

@export_category("Configuración")
@export var duracion_segundos: float = 30.0
@export var auto_iniciar: bool = true

@export_category("Sprites de Números (0 al 9)")
# Arrastra tus 10 imágenes aquí en orden: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
@export var imagenes_numeros: Array[Texture2D] = []

var tiempo_restante: float = 0.0
var activo: bool = false
var ultimo_segundo: int = -1

var digito_decenas: TextureRect
var digito_unidades: TextureRect

func _ready() -> void:
	_preparar_nodos_pantalla()
	tiempo_restante = duracion_segundos
	actualizar_pantalla()
	if auto_iniciar:
		iniciar()

func _preparar_nodos_pantalla() -> void:
	# Limpiamos cualquier hijo previo
	for hijo in get_children():
		hijo.queue_free()
		
	# Creamos las dos casillas fijas para decenas y unidades
	digito_decenas = TextureRect.new()
	digito_unidades = TextureRect.new()
	
	for rect in [digito_decenas, digito_unidades]:
		rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(rect)

func iniciar() -> void:
	await get_tree().create_timer(2.0).timeout
	tiempo_restante = duracion_segundos
	activo = true

func detener() -> void:
	activo = false

func _process(delta: float) -> void:
	if not activo:
		return
		
	tiempo_restante -= delta
	var seg_int = max(0, int(ceil(tiempo_restante)))
	
	# Cambiamos las imágenes solo cuando cambia el segundo
	if seg_int != ultimo_segundo:
		ultimo_segundo = seg_int
		actualizar_pantalla()
		
	if tiempo_restante <= 0.0:
		tiempo_restante = 0.0
		activo = false
		actualizar_pantalla()
		print("--- TIEMPO AGOTADO: MATANDO AL JUGADOR ---")
		ControladorMuerte.a_muerto = true

func actualizar_pantalla() -> void:
	if imagenes_numeros.size() < 10:
		return
		
	var seg = max(0, int(ceil(tiempo_restante)))
	var decenas = seg / 10
	var unidades = seg % 10
	
	# Asignamos las texturas de los dígitos correspondientes
	if decenas < imagenes_numeros.size():
		digito_decenas.texture = imagenes_numeros[decenas]
	if unidades < imagenes_numeros.size():
		digito_unidades.texture = imagenes_numeros[unidades]
