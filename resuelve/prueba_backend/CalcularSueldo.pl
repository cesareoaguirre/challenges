#!usr/bin/perl
# Prueba Backend Resuelve versión PERL
# # @CesareoAguirre
# 30 de julio del 2020
#

#
# MODO DE USO
# Está planteado para poder ejecutarse por otros scripts.
#
# Desde la terminal, ejecutar lo siguiente:
# cat json.txt | perl CalcularSueldo.pl > sueldos.txt
#
#
#
# PROGRAMACIÓN FUNCIONAL
#
# Importar JSON
# Convertir el INPUT en JSON
# Procesar cada entrada del JSON como un objeto
#
use JSON;
use Data::Dumper;

# Nuestra fuente de datos es pasada por STDIN (el .pl puede ser llamado por otro módulo).
# .
$input = ( $/ );
#$input =~ s/^\s+$//;
$json = JSON->new->allow_nonref;
print "'$input'\n";
if ( $input eq ""){
	print "no se incluyó ningún dato json con los goles de los jugadores\n";
	exit ;
}

$json_txt = do { local $/; <> };

$json_obj = decode_json( $json_txt );
#
# Los niveles de goles al mes. Aclarar que este es el mejor escenario y pasar un nivel inexistente provocará falla en el script en tiempo de ejecución.
$NIVELES ={
	A=>5,
	B=>10,
	C=>15,
	Cuauh=>20,
};
# Iteramos en cada jugador y asignamos su sueldo total y sus goles mínimos.
for my $jugador ( @$json_obj ) {
	my $nivel= %$jugador{'nivel'};
	my $goles_minimos= %$NIVELES{ $nivel };
	my $goles = %$jugador{'goles'}; 
	my $alcance_bono= $goles / $goles_minimos;
 	my $sueldo= %$jugador{'sueldo'};
	my $bono=  %$jugador{'bono'};
	my $bono_total= $bono * $alcance_bono; 
	my $sueldo_total= $sueldo + $bono;
	$jugador->{'goles_minimos'}=$goles_minimos;
	$jugador->{'sueldo_completo'}=$sueldo_total;
	print "Jugador " . %$jugador{'nombre'} . "\n";
	print "nivel: $nivel, goles: $goles / $goles_minimos = $alcance_bono \n";
	print "bono: $bono\n";
	print "sueldo total $sueldo + $bono_total";
	print "-----------------\n";

}
# Lo enviamos a STDOUT
$salida= $json->pretty->encode( $json_obj );
print STDOUT $salida;
