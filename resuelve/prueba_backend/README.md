Es necesario instalar un par de dependencias:

Linux:

	sudo cpanm Data::Dumper
	sudo cpanm JSON


Este script se puede ejecutar desde terminal Linux como

	cat json.txt | perl CalcularSueldo.pl

Terminal de Windows como

	type .\json.txt | perl .\CalcularSueldo.pl


Siendo json.txt la entrada de los goles de los jugadores y obtiene como resultado la salida de los sueldos calculados.
