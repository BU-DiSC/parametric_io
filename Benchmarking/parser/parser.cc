#include<iostream>
#include <fstream>
#include <string>
#include <cstdlib>
using namespace std;

int main()
{
    string line, matchstr;
    string resultstr;
    string unitstr;
    string threadcount;
    string iops;
    string pattern;
    string bw;
    double lat,bwval,iopsval;
    int index0, index, index1, index2, index3;
    int index4, index5, index8;
    int index6, index7, index9;

    int count=0;
    ifstream infile ("out_r4.txt");
    ofstream outfile ("out_r4.txt");

    //For appending
    // ofstream outfile;
    // outfile.open ("results.txt", std::ofstream::out | std::ofstream::app);

    if (infile.is_open())
    {
        while (getline (infile,line) )
        {
            index0 = line.find("tart");
            index = line.find(" process");
            index1 = line.find("clat (");
            index4 = line.find("read: IOPS");
            index6 = line.find("write: IOPS");
            index9 = line.find("util");
            

            if (index0 > 0) 
            {
                threadcount = line.substr (index0 + 8,index - index0 - 8);
            }

            if (index4 > 0) 
            {                
                index5 = line.find(", BW");
                if (isalpha(line[index5-1])) 
                {
                    iops = line.substr (index4 + 11,index5 - index4 - 12);
                    iopsval = atof(iops.c_str());
                }
                else 
                {
                    iops = line.substr (index4 + 11,index5 - index4 - 11);
                    iopsval = atof(iops.c_str());
                    iopsval = iopsval/1000.0;
                }
                index8 = line.find("MiB/s");
                bw = line.substr (index5 + 5,index8 - index5 - 5);
                bwval = atof(bw.c_str());
                if(index8 < 0)
                {
                    index8 = line.find("KiB/s");
                    bw = line.substr (index5 + 5,index8 - index5 - 5);
                    bwval = atof(bw.c_str());
                    bwval = bwval/1000.0;
                }
                pattern = "read";
            }

            if (index6 > 0) 
            {
                index7 = line.find(", BW");
                if (isalpha(line[index7-1])) 
                {
                    iops = line.substr (index6 + 12,index7 - index6 - 13);
                    iopsval = atof(iops.c_str());
                }
                else 
                {
                    iops = line.substr (index6 + 12,index7 - index6 - 12);
                    iopsval = atof(iops.c_str());
                    iopsval = iopsval/1000.0;
                }


                iops = line.substr (index6 + 12,index7 - index6 - 13);
                index8 = line.find("MiB/s");
                bw = line.substr (index7 + 5,index8 - index7 - 5);
                bwval = atof(bw.c_str());
                if(!index8)
                {
                    index8 = line.find("KiB/s");
                    bw = line.substr (index7 + 5,index8 - index7 - 5);
                    bwval = atof(bw.c_str());
                    bwval = bwval/1000.0;
                }
                pattern = "write";
            }


            if (index1 > 0) 
            {
                //cout << index << endl;
                unitstr = line.substr (index1+6,4);
                index2 = line.find("avg=");
                index3 = line.find(", stdev=");
                resultstr = line.substr (index2+4,index3-index2-4);
                lat = atof(resultstr.c_str());
                //cout << unitstr << endl;
                if ((unitstr.compare("nsec") == 0)) {
                    lat = lat/1000.0;
                }
                if ((unitstr.compare("msec") == 0)) {
                    lat = lat*1000.0;
                }
            }
            if (index9 > 0)
            {

                if (outfile.is_open())
                {
                    outfile << threadcount << "\t" << iopsval << "\t" << bwval << "\t" << lat << endl;
                }
                else cout << "Unable to open output file";


                //cout << pattern << " : Thread Count: " << threadcount << " IOPS: " << iops << " BW: " << bw << " Latency: " << lat << endl;
                //cout << threadcount << "\t" << iops << "\t" << bw << "\t" << lat << endl;
            }

        }
        infile.close();
    }
    else cout << "Unable to open input file";

    

    outfile.close();
    //cout << count << endl;
    return 0;
}