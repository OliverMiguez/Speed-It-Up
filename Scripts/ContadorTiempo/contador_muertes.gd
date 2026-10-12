extends HBoxContainer
class_name ContadorMuertes

@export_category("Icono de Calavera")
@export var sprite_calavera: Texture2D # Arrastra el sprite de la calavera aquí

@export_category("Sprites de Números (0 al 9)")
# Arrastra tus 10 imágenes en orden: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
@export var imagenes_numeros: Array[Texture2D] = []

func _ready() -> void:
	actualizar_pantalla()

func actualizar_pantalla() -> void:
	if imagenes_numeros.size() < 10:
		return
		
	# Limpiamos el contenedor para regenerar el icono y los dígitos
	for hijo in get_children():
		hijo.queue_free()
		
	# 1. Dibujamos el icono de la Calavera al principio
	if sprite_calavera:
		var rect_calavera = TextureRect.new()
		rect_calavera.texture = sprite_calavera
		rect_calavera.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		rect_calavera.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(rect_calavera)
		
	# 2. Obtenemos las muertes acumuladas desde ControladorMuerte
	var muertes_totales = 0
	if "muertes" in ControladorMuerte:
		muertes_totales = ControladorMuerte.muertes
	elif "contador_muertes" in ControladorMuerte:
		muertes_totales = ControladorMuerte.contador_muertes

	# Convertimos el número a texto de 2 dígitos mínimos (ej: 0 -> "00", 7 -> "07", 14 -> "14")
	var texto_muertes = "%02d" % muertes_totales
	
	# 3. Dibujamos las imágenes de los dígitos a la derecha de la calavera
	for char_digito in texto_muertes:
		var digito_int = char_digito.to_int()
		if digito_int >= 0 and digito_int < imagenes_numeros.size():
			var rect_digito = TextureRect.new()
			rect_digito.texture = imagenes_numeros[digito_int]
			rect_digito.expand_mode = TextureRect.EXPAND_KEEP_SIZE
			rect_digito.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			add_child(rect_digito)
