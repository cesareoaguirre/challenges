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
#
# Rutina de apoyo 
sub max ($$) { $_[$_[0] < $_[1]]}
sub min ($$) { $_[$_[0] > $_[1]]}
#
# Nuestra fuente de datos es pasada por STDIN (el .pl puede ser llamado por otro módulo).
# .
$input = ( $/ );
#$input =~ s/^\s+$//;
$json = JSON->new->allow_nonref;
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
#
#
# Obtenemos los goles y los mínimos globales
$goles_minimos = 0;
$goles_equipo = 0;
for my $jugador ( @$json_obj ) {
	my $nivel= %$jugador{'nivel'};
	my $goles_minimos_jugador = %$NIVELES{ $nivel };
	my $goles_jugador = %$jugador{'goles'}; 
	$jugador->{'goles_minimos'} = $goles_minimos_jugador;
	$jugador->{'alcance'} = min( 1, $goles_jugador / $goles_minimos_jugador );
	#print "Jugador  " . %$jugador{'nombre'} . " de nivel: $nivel, goles: $goles_jugador / $goles_minimos_jugador = ". %$jugador{'alcance'} ." \n";
	$goles_minimos += $goles_minimos_jugador;
	$goles_equipo += $goles_jugador;
}
# 0<= $alcance_equipo <=1

my $alcance_equipo= min( 1, $goles_equipo / $goles_minimos );
#print "Global de goles: $goles / $goles_minimos = $alcance_equipo \n";
#
# calculamos el sueldo de cada jugador
for my $jugador ( @$json_obj ) {
	my $nivel= %$jugador{'nivel'};
	my $goles_minimos_jugador = %$NIVELES{ $nivel };
	my $goles_jugador = %$jugador{'goles'}; 
 	my $sueldo_jugador= %$jugador{'sueldo'};
	my $bono_jugador = %$jugador{'bono'};
	my $alcance_jugador = %$jugador{'alcance'};
	my $alcance_completo_jugador = ( $alcance_equipo + $alcance_jugador )/2;
	my $bono_total= $bono_jugador * $alcance_completo_jugador; 
	my $sueldo_total= sprintf("%.2f", $sueldo_jugador + $bono_total );
	$jugador->{'sueldo_completo'}=$sueldo_total;
	#print "Jugador " . %$jugador{'nombre'} . "\n";
	#print "	alcance completo del jugador $alcance_completo_jugador\n";
	#print "	bono: $bono_jugador * $alcance_completo_jugador\n";
	#print "	sueldo total $sueldo_jugador + $bono_total";
	#print "	-----------------\n";
	delete %$jugador{'alcance'};
}
#
# Lo enviamos a STDOUT
$salida= $json->pretty->encode( $json_obj );
print STDOUT $salida;
