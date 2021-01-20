************
Run script.sh. There must be a large file named testfile in the directory
************
Note that this is just one script. We used many such scripts for different experiments. But the core structure of the script is same

./buffermanager -b 10 -n 1000 -x 1000 -r 50 -a 2
./buffermanager -b 5 -f testfile3 -x 10 -e 50 -a 1 -s 100 -d 100 -r 1 -w 1 -k 1 -W 3
./buffermanager -b 5 -f testfile3 -x 20 -e 50 -a 3 -s 100 -d 100 -r 1 -w 8 -k 3 -W 3 -v 2


int buffer_size_in_pages;	// b
int disk_size_in_pages;   	// n
int num_operations;    		// x
int perct_reads;       		// e
int perct_writes;      		// e'
float skewed_perct;      	// s
float skewed_data_perct; 	// d
long read_cost;     		// r
long write_cost;    		// w
int pin_mode;   		// p
int verbosity;         		// v
int algorithm;         		// a
int concurrency;         	// k
int window;			// W


Algorithms
1 - LRU
2 - CONE-a
3 - CONE-Xa
4 - COW-a
5 - COW-Xa
