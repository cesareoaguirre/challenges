# @cesareoaguirre
# el objetivo de este script es generar un RegEx para verificaci�n de CURP en M�xico
# Este caso es para una verificaci�n en PoweShell
$curp="ROVI490617HSPDSS05"
$curp -match '[a-z][aeiou][a-z][a-z]\d\d\d\d\d\d[hm][a-z][a-z][b-df-hj-np-tv-z][b-df-hj-np-tv-z][b-df-hj-np-tv-z]\w\d'