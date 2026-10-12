extends Node

# True cuando el jugador muere en la partida actual
var a_muerto: bool = false

# Contador global de muertes (persiste al reiniciar el nivel)
var muertes: int = 0

var cont_nvl_2 = false

# Llama a esto cuando el jugador inicie un nivel desde el menú/selector para reiniciar las muertes
func reiniciar_muertes() -> void:
	muertes = 0
	a_muerto = false

# Llama a esto cuando comience el nivel para limpiar la bandera de muerte
func resetear_estado() -> void:
	a_muerto = false
