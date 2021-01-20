#!/bin/sh

term_x=800
term_y=600
term_font_size=26
tics_font_size=20
key_font_size=19
term_font_name="Linux Libertine"
key_width=0.6
key_rows=1

gnuplot -persist <<-EOFMarker
	set term qt size $term_x, $term_y
	set style line 2 lc rgb '#09ad00' lt 1 lw 1
	set yrange [0:1.2]
	set term qt font "$term_font_name, $term_font_size"
	set style data histogram
	set style histogram cluster gap 1
	set style fill pattern border -1
	set boxwidth 0.9
	set xtics format ""
	set grid ytics
	set key right
	set key width $key_width
	set key vertical maxrows $key_rows
	set tics font "$term_font_name,$tics_font_size"
	set key font "$term_font_name,$key_font_size"
	# set xlabel "Algorithms"
	set ylabel "Speedup" offset 3

	# set title "Workload: $x op ($e% R); B=$b, N=$n ($s% op on $d% data)"
	plot "normalized_io.txt" using 2:xtic(1) title "{/Symbol a} = 1" ls 2, \
            '' using 3 title "{/Symbol a} = 2" ls 2, \
            '' using 4 title "{/Symbol a} = 4" ls 2, \
            '' using 5 title "{/Symbol a} = 8" ls 2
	pause -1
EOFMarker