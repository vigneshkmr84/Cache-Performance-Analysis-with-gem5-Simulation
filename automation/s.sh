#!/bin/bash
### Author - Vignesh;
### Script will run the benchmarks for the given cache configurations



# time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c \ 
# $BENCHMARK -o "$ARGUMENT" -I 500000000 --cpu-type=$cpu_type --caches --l2cache --l1d_size=$l1d_size \ 
# --l1i_size=$l1i_size --l2_size=$l2_size --l1d_assoc=$l1d_assoc --l1i_assoc=$l1i_assoc --l2_assoc=$l2_assoc --cacheline_size=$block_size 

# rm -rf ~/cache-results/

getStats(){
        
        printf "\nCalculating CPI \n"

        OUT_DIR=$9
        STATS_FILE="$OUT_DIR/stats.txt"
        GREP_FILE="$OUT_DIR/grep.values"
        CSV_FILE=~/cache-results/470/block-$8/l2-$4_$7/output.csv

        echo "STATS FILE : $STATS_FILE"
        echo "GREP FILE : $GREP_FILE"

        dcache_miss=$(grep -i 'system.cpu.dcache.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')
        icache_miss=$(grep -i 'system.cpu.icache.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')
        l2_miss=$(grep -i 'system.l2.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')
        cpi=$(echo "scale = 8; 1 + ($dcache_miss + $icache_miss)*6 + $l2_miss*50 " | bc)

        echo "l1_dcache_miss = $dcache_miss"
        echo "l1_icache_miss = $icache_miss"
        echo "l2_miss = $l2_miss"
        echo "CPI: $cpi"

        echo "Adding important configurations from stats file"
        #cat $OUT_DIR/config.ini | grep -i "\[system.cpu.branchPred\]" -A10 > $GREP_FILE
        #echo "Checking stats file"

        cat $OUT_DIR/stats.txt | grep -i -E "system.cpu.dcache.overall_miss_rate::total|system.cpu.icache.overall_miss_rate::total|system.l2.overall_miss_rate::total" > $GREP_FILE
        printf "l1.icache.miss_penality \t\t\t 6\n" >> $GREP_FILE
        printf "l1.dcache.miss_penality \t\t\t 6\n" >> $GREP_FILE
        printf "l2.miss_penality \t\t\t\t 50\n" >> $GREP_FILE
        printf "system.cpi::total \t\t\t     $cpi \n" >> $GREP_FILE

        #cat $GREP_FILE

        echo "Updating stats in CSV file - $CSV_FILE"
        touch $CSV_FILE
        echo "$2, $3, $4, $5, $6, $7, $8, $dcache_miss, $icache_miss, $l2_miss, $cpi" >> $CSV_FILE
}

runSimulation(){

    if [ $# -ne 8 ]; then 
        echo "Missing parameters; Toal 8 parameters are needed"
        echo "Input arguments passed - $*"
        exit 1
    fi 

    # Sample Output Directory - ./470/block-32/l2-256kB_4/inst-64kB_1_data-64kB_32
    # Sampke Csv File - ./470/block-32/l2-256kB_4/l2-256kB_4_output.csv
    OUT_DIR=~/cache-results/470/block-$8/l2-$4_$7/inst-$3_$6_data-$2_$5
    CSV_FILE="~/cache-results/470/block-$8/l2-$4_$7/l2-$4_$7_output.csv"
    GEM5_DIR=~/gem5/gem5
    BENCHMARK=./src/benchmark
    ARGUMENT="20 reference.dat 0 1 ~/Project1_SPEC/470.lbm/data/100_100_130_cf_a.of"
    echo "Output_dir - $OUT_DIR"
    mkdir -pv $OUT_DIR
    #touch $CSV_FILE

    #command="time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o \"20 reference.dat 0 1 ~/Project1_SPEC/470.lbm/data/100_100_130_cf_a.of\" -I 500000000 --cpu-type=$1 --caches --l2cache --l1d_size=$2 --l1i_size=$3 --l2_size=$4 --l1d_assoc=$5 --l1i_assoc=$6 --l2_assoc=$7 --cacheline_size=$8"
    #echo "$command"
    time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o "20 reference.dat 0 1 /home/012/v/vx/vxt200003/Project1_SPEC/470.lbm/data/100_100_130_cf_a.of" -I 500000000 --cpu-type=$1 --caches --l2cache --l1d_size=$2 --l1i_size=$3 --l2_size=$4 --l1d_assoc=$5 --l1i_assoc=$6 --l2_assoc=$7 --cacheline_size=$8
    
    #getStats "/Users/vignesh/Downloads/ca-project/results/bimode_results/m5out_458/btb_2048/global2048_choice2048"
    #getStats "./"
    getStats $1 $2 $3 $4 $5 $6 $7 $8 $OUT_DIR
    printf "\n\n"
}

# time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c \ 
# $BENCHMARK -o "$ARGUMENT" -I 500000000 --cpu-type=$1 --caches --l2cache --l1d_size=$2 \ 
# --l1i_size=$3 --l2_size=$4 --l1d_assoc=$5 --l1i_assoc=$6 --l2_assoc=$7 --cacheline_size=$8



echo "Starting script"
              # cpu_type l1d_s    l1i_s     l2_s     l1d_a   l1i_a  l2_a   block_size
#runSimulation "timing"   "128kB"  "128kB"   "1MB"    "2"     "2"    "2"    "32"
#runSimulation "timing"  "256kB"  "128kB"   "512MB"  "4"     "2"    "4"    "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "1" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "2" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "4" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "32" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "1" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "2" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "4" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "32" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "1" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "2" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "4" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "32" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "1" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "2" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "4" "1" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "32" "1" "32"

 runSimulation "timing" "64kB" "64kB" "256kB" "1" "1" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "2" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "4" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "32" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "1" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "2" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "4" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "32" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "1" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "2" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "4" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "32" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "1" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "2" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "4" "2" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "32" "2" "32"

 runSimulation "timing" "64kB" "64kB" "256kB" "1" "1" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "2" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "4" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "32" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "1" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "2" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "4" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "32" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "1" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "2" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "4" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "32" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "1" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "2" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "4" "4" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "32" "4" "32"

 runSimulation "timing" "64kB" "64kB" "256kB" "1" "1" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "2" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "4" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "1" "32" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "1" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "2" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "4" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "2" "32" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "1" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "2" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "4" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "4" "32" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "1" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "2" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "4" "32" "32"
 runSimulation "timing" "64kB" "64kB" "256kB" "32" "32" "32" "32"


echo "End of Script"
exit 0


