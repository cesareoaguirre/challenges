No requiere dependencias especiales:


MODO DE USO
Este script se puede ejecutar desde terminal Linux como

	sudo phpunit --bootstrap ./src/autoload.php test/


Puede ocuparse esta clase, previo un include, mediante un string generador de un JSON:

	SueldosJugadores::evaluarSueldoJugadores( $jugadores_string )


ó mediante un objeto JSON

	SueldosJugadores::evaluarSueldoJugadoresJSON( $jugadores_json )


Ambos casos devuelven un objeto JSON, donde cada elemento Jugador contiene ahora su alcance, goles mínimos y su sueldo_completo
