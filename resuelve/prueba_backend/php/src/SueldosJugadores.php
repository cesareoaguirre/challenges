<?php
#!usr/bin/perl
# Prueba Backend Resuelve versión PERL
# # @CesareoAguirre
# adaptación a php el 8 de marzo del 2021
#

#
# MODO DE USO
# Estando en la carpeta raíz del php, es posible ejecutar pruebas
# unitarias (preliminar) mediante:
# sudo phpunit --bootstrap ./src/autoload.php test/
#
#
# Puede ocuparse esta clase, previo un include,
# mediante un string generador de un JSON:
# SueldosJugadores::evaluarSueldoJugadores( $jugadores_string )
#
# ó mediante un objeto JSON
# SueldosJugadores::evaluarSueldoJugadoresJSON( $jugadores_json )
#
# Ambos casos devuelven un objeto JSON, donde cada elemento Jugador
# contiene ahora su alcance, goles mínimos y su sueldo_completo
#
class SueldosJugadores{
    public function __construct(){
        throw new Exception( "SueldosJugadores no debe instanciarse\n" );
    }
    private static $NIVEL_GOLES = [
        "A" => 5,
        "B" => 10,
        "C" => 15,
        "Cuauh" => 20,
    ];
   public static  function obtenerGolesMinimosPorNivel( $nivel ){
        #
        # Los NIVEL_GOLES de goles al mes. 
        # Aclarar que este es el mejor escenario y 
        # pasar un nivel inexistente o no definido provocará falla en el script 
        # en tiempo de ejecución.
        $goles_minimos_jugador = self::$NIVEL_GOLES[ $nivel ];
        return $goles_minimos_jugador;
    }
    public static  function calcularAlcanceGlobalEquipo($jugadores){
        $goles_minimos=0;
        $goles_equipo=0;
        foreach( $jugadores as $jugador ) {
            $goles_jugador = $jugador->{'goles'}; 
            $goles_minimos_jugador=self::obtenerGolesMinimosPorNivel( $jugador->{'nivel'} );
            $goles_minimos += $goles_minimos_jugador;
            $goles_equipo += $goles_jugador;
            $jugador->{'alcance'} = min( 1, $goles_jugador / $goles_minimos_jugador );
            $jugador->{'goles_minimos'} = $goles_minimos_jugador;

        }
        $alcance_equipo= min( 1, $goles_equipo / $goles_minimos );
        /* 0<= $alcance_equipo <=1 */
        $alcance_equipo = min( [1, $alcance_equipo] ); 
        return $alcance_equipo;
    }
    public static  function evaluarSueldoJugadoresJSON( $jugadores /*JSON*/ ){
        self::calcularAlcanceGlobalEquipo( $jugadores );
        $alcance_equipo =self::calcularAlcanceGlobalEquipo( $jugadores );
        foreach( $jugadores as $jugador ){
            $nivel= $jugador->{'nivel'};
            $goles_jugador = $jugador->{'goles'}; 
            $sueldo_jugador= $jugador->{'sueldo'};
            $bono_jugador = $jugador->{'bono'};
            $alcance_jugador = $jugador->{'alcance'};
            $alcance_completo_jugador = ( $alcance_equipo + $alcance_jugador )/2;
            $bono_total= $bono_jugador * $alcance_completo_jugador; 
            $sueldo_total= sprintf("%.2f", $sueldo_jugador + $bono_total );
            $jugador->{'sueldo_completo'}=$sueldo_total;
        }
    }
    public static function evaluarSueldoJugadores( $jugadores_string /* string */){
        $jugadores_json = json_decode( $jugadores_string);  
        self::evaluarSueldoJugadoresJSON( $jugadores_json );
        var_dump( $jugadores_json );
        return $jugadores_json;
    }
    public static function cargarJSON( $jsonpath="./json.txt" ){
        if ( !file_exists( $jsonpath ) ){
            echo( "No se encuentra el archivo $jsonpath\n" );
            exit(1);
        }else if ( $datos = file_get_contents ( $jsonpath ) ){
            if ( $datos == ""){
                print "no se incluyó ningún dato json con los goles de los jugadores\n";
                exit( 1 ) ;
            }
            var_dump( $datos );
            self::evaluarSueldoJugadores( $datos );
            exit(0);
        }else{
            echo( "error al leer el archivo $jsonpath\n" );
        }
    }

    public static function getVersion(){
        return "1";
    }

}
?>