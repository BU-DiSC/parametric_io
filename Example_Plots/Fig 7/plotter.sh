#!/bin/sh

term_x=800	# output canvas size
term_y=600
pdf_x=4
pdf_y=3
term_font_size=26
tics_font_size=20
key_font_size=17
label_font_size=24
term_font_name="Linux Libertine"
key_width=1.6
key_rows=1
filename="device_latency_w3.txt"
declare -a arr=("exp1_workload1.pdf" "exp1_workload2.pdf" "exp1_workload3.pdf" "exp1_workload4.pdf")
q=0.16

b=20000
n=344066
x=2000000
e=50
s=50
d=50
i=0


for filename in "device_latency_w1.txt" "device_latency_w2.txt" "device_latency_w3.txt" "device_latency_w4.txt"
do
	max_io=$(cut -f 2 $filename | sort -n | tail -1 | head -1)
	# echo $max_io
	offset=$(bc <<< "$max_io * $q")
	# echo $offset

	gnuplot -persist <<-EOFMarker
		set term qt size $term_x, $term_y
		set style line 2 lc rgb 'light-red' lt 1 lw 1
		set yrange [0:530]
		set term qt font "$term_font_name, $term_font_size"
		set style data histogram
		set style histogram cluster gap 1
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
		set ylabel "Latency (s)" offset 0

		# set title "Workload 4 : 2M op ($e% R); B=$b, N=$n ($s% op on $d% data)"
		# set label 11 center at graph 0.5,char 1 "Trace $(($i+1)) " font "$term_font_name, $term_font_size"
		# set bmargin 4.5
		plot "$filename" using 2:xtic(1) fs pattern 3 title "SOA" ls 2, \
	            '' using 3 fs pattern 4 title "COW(n)" ls 2, \
	            '' using 4 fs pattern 1 title "COW-X(n)" ls 2
		set terminal pdfcairo size $pdf_x, $pdf_y
		set output "temp.pdf"
		replot
		unset output
		unset terminal            
		pause -1
	EOFMarker
	pdfcrop temp.pdf ${arr[$i]}
	i=`expr $i + 1`
done

pdfjam exp1_workload1.pdf exp1_workload2.pdf exp1_workload3.pdf exp1_workload4.pdf --delta '10 0' --nup 4x1 --landscape --outfile exp1.pdf
pdfcrop exp1.pdf exp1.pdf