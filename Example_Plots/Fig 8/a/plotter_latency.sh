#!/bin/sh

term_x=900	# output canvas size
term_y=600
pdf_x=4.5
pdf_y=3
term_font_size=26
tics_font_size=18
key_font_size=14
term_font_name="Linux Libertine"
label_font_size=24
key_width=4
key_rows=2
filename="ssd_latency.txt"
q=0.2

b=20000
n=344066
x=2000000
e=50
s=50
d=50

max_io=$(cut -f 2 $filename | sort -n | tail -1 | head -1)
echo $max_io
offset=$(bc <<< "$max_io * $q")

gnuplot -persist <<-EOFMarker
	set term qt size $term_x, $term_y
	set style line 2 lc rgb 'light-red' lt 1 lw 1
	set yrange [0:$max_io+$offset]
	set term qt font "$term_font_name, $term_font_size"
	set style data histogram
	set style histogram cluster gap 2
	set style fill pattern border -1
	set boxwidth 0.9
	set xtics format ""
	set grid ytics
	set key top
	set key width $key_width
	set key vertical maxrows $key_rows
	set tics font "$term_font_name,$tics_font_size"
	set key font "$term_font_name,$key_font_size"
	set ylabel font "$term_font_name,$label_font_size"
		set ylabel "Latency (s)" offset 1.3

	# set title "Workload 4 : 2M op ($e% R); B=$b, N=$n ($s% op on $d% data)"
	plot "$filename" using 2:xtic(1) fs pattern 3 title "LRU" ls 2, \
            '' using 3 fs pattern 4 title "LRU+COW" ls 2, \
            '' using 4 fs pattern 2 title "CFLRU" ls 2, \
            '' using 5 fs pattern 5 title "CFLRU+COW" ls 2, \
            '' using 6 fs pattern 1 title "LRUWSR" ls 2, \
            '' using 7 fs pattern 0 title "LRUWSR+COW" ls 2
    set terminal pdfcairo size $pdf_x, $pdf_y
		set output "ssd_latency.pdf"
		replot
		unset output
		unset terminal
	pause -1
EOFMarker
pdfcrop ssd_latency.pdf ssd_latency.pdf

