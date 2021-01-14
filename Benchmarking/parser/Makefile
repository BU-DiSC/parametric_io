#all:async async2
all:parser

async: parser.cc
	#g++ -ggdb -O0 -o async async.cc -lrt
	g++ -o parser parser.cc

clean:
	/bin/rm -f parser