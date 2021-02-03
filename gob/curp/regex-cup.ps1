# @cesareoaguirre
# el objetivo de este script es generar un RegEx para verificación de CURP en México
# Este caso es para una verificación en PoweShell
$curp="ROVI490617HSPDSS05"
$curp -match '[a-z][aeiou][a-z][a-z]\d\d\d\d\d\d[hm][a-z][a-z][b-df-hj-np-tv-z][b-df-hj-np-tv-z][b-df-hj-np-tv-z]\w\d'