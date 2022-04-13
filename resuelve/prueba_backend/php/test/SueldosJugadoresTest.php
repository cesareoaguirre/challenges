<?php
use PHPUnit\Framework\TestCase;
final class SueldosJugadoresTest extends TestCase {
        public function testObtenerGolesMinimosPorNivel(){
                echo( "testObtenerGolesMinimosPorNivel...\n");
                $this->assertEquals(
                        5,
                        SueldosJugadores::obtenerGolesMinimosPorNivel( "A" )
		);
                $this->assertEquals(
                        10,
                        SueldosJugadores::obtenerGolesMinimosPorNivel( "B" )
		);
                $this->assertEquals(
                        15,
                        SueldosJugadores::obtenerGolesMinimosPorNivel( "C" )
		);
                $this->assertEquals(
                        20,
                        SueldosJugadores::obtenerGolesMinimosPorNivel( "Cuauh" )
		);
        }
        public function testCargarJSON(){
                echo( "testCargarJSON...\n");
                $this->assertTrue(
                        SueldosJugadores::cargarJSON( dirname( __FILE__) . "/../src/json.txt" )
                );
        }
}

?>
