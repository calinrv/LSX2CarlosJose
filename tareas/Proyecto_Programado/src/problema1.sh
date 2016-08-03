#!/bin/bash
###Se establece la direccion Path en donde se encuentra el archivo script de problema1
DATA=/home/sysadmin/LSX2CarlosRojas/LSX2CALINRV2/tareas/Proyecto_Programado/problema1/hojasDatos
###Se establece la ruta de almacenamiento de archivos csv y datos

###El archivo csv va a poseer la salida de data
OUT_DATA=$DATA/archivos_csv
GRAF_DATA=$DATA/datos_graf
FULL_DATA=$DATA/full_datos

###Se crean las carpetas que van a obtener los archivos y datos
mkdir $DATA/archivos_csv
mkdir $GRAF_DATA
mkdir $FULL_DATA

##se establece la variable m la cual se inicia en 0
m=0

### se crea un for para recorrer los datos con formato xls
for i in 'find $DATA -name''*.xls'
do

	echo "Procesando archivo $i"

	xls2csv $i > $OUT_DATA/data-$m.csv
###la vaiable m permite seguir contando de uno en uno y luego se imprime la salida de datos
	let m=m+1
done 2> error1.log

m=0

for e in 'find $OUT_DATA -name "*.csv"'
do
	echo "Dando Formato de datos para graficar el archivo $e"
###con la expresion de cat damos formato a la salida de datos en donde se ordenan por columnas del 1 al 5 y luego se eimprimen los datos
cat $e | awk -F "\",\"" '{print $1 " " $2 " " $3 " " $4 " " $5 }' | sed '1,$ s/"//g' | sed '1 s/date/#date/g' > $GRAF_DATA/graf-$m.dat

	let m=m+1

done 2> error2.log


##el metodo if se encarga de verificar el estado del archivo full.dat y si se encuentra lleno el mismo se elimina para que no se genere un duplicado en cada ejecucion
if [-a $FULL_DATA/full.dat]
then
	rm $FULL_DATA/full.dat
	echo "Archivo full.dat borrado"
fi 2> errorIf.log

for k in 'find $GRAF_DATA -name "*.dat"'
do
	sed 'Id' $k >> $FULL_DATA/full.dat
	echo "Procesando archivo $k"

done 2> error3.log

FMT_BEGIN='20110206 0000'
FMT_END='20110206 0200'
FMT_X_SHOW=%H:%M
DATA_DONE=$FULL_DATA/full.dat

####Como se menciona en archivo plot el metodo graficar se encarga de dar formato a la salida de los datos y se imprime mediante la imagen fig1 y se establecen los rangos de inicio y fin
graficar()
{
	gnuplot << EOF 2> error.log 
	set xdata time
	set timefmt "%Y%m%d%H%M"
#	set xrange ["$FMT_BEGIN" : "$FMT_END"]
	set format x "$FMT_X_SHOW"
	set terminal png
	set output 'fig1.png'
	plot "$DATA_DONE" using 1:3 with lines title "sensor1", "$DATA_DONE using 1:4 with linespoints title "sensor2"

EOF
}

graficar
