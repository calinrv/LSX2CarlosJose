#!/bin/bash
###se crean las variables de BEGIN y END los cuales se utilizaran para establecer los rangos de inicio y de fin
FMT_BEGIN='20110206 0000'
FMT_END='20110206 0200'
FMT_X_SHOW=%m/%d

graficar()
{

###Se crear este metodo el cual  establece el rando de fecha inicio hasta fecha fin a su vez se establece el formato que se va desplegar, el archivo graf-o contiene el grafico y se ordena mediante los rangos y los Sensores 1 y 2
	gnuplot << EOF 2> error.log
	set xdata time
	set timefmt "%Y%m%d%H%M"
	set xrange ["$FMT_BEGIN" : "$FMT_END"]
	set format x "$FMT_X_SHOW"
	set terminal png
	set output 'fig1.png'
	plot "graf-0.dat" using 1:3 with lines titles "sensor1","graf-0.dat" using 1:4 with linespoints title "sensor2"


EOF
}

graficar
