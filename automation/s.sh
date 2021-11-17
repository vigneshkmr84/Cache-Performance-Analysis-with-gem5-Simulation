#!/bin/bash
### Author - Vignesh;
### Script will run the benchmarks for the given cache configurations




# time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c \ 
# $BENCHMARK -o "$ARGUMENT" -I 500000000 --cpu-type=timing --caches --l2cache --l1d_size=128kB \ 
# --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=4 --cacheline_size=64 


# time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c \ 
# $BENCHMARK -o "$ARGUMENT" -I 500000000 --cpu-type=$cpu_type --caches --l2cache --l1d_size=$l1d_size \ 
# --l1i_size=$l1i_size --l2_size=$l2_size --l1d_assoc=$l1d_assoc --l1i_assoc=$l1i_assoc --l2_assoc=$l2_assoc --cacheline_size=$block_size 


# time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c \ 
# $BENCHMARK -o "$ARGUMENT" -I 500000000 --cpu-type=$1 --caches --l2cache --l1d_size=$2 \ 
# --l1i_size=$3 --l2_size=$4 --l1d_assoc=$5 --l1i_assoc=$6 --l2_assoc=$7 --cacheline_size=$8


getStats(){
        OUT_DIR=$1
        STATS_FILE="$OUT_DIR/stats.txt"
        GREP_FILE="$OUT_DIR/grep.values"
        echo "STATS FILE : $STATS_FILE"
        echo "GREP FILE : $GREP_FILE"

        dcache_miss=$(grep -i 'system.cpu.dcache.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')
        icache_miss=$(grep -i 'system.cpu.icache.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')

        l2_miss=$(grep -i 'system.l2.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')

        echo "l1_dcache_miss = $dcache_miss"
        echo "l1_icache_miss = $icache_miss"

        echo "l2_miss = $l2_miss"

        cpi=$(echo "scale = 8; 1 + ($dcache_miss + $icache_miss)*6 + $l2_miss*50 " | bc)

        echo "CPI: $cpi"

        echo "Adding important configurations from stats file"
        #cat $OUT_DIR/config.ini | grep -i "\[system.cpu.branchPred\]" -A10 > $GREP_FILE
        #echo "Checking stats file"

        cat $OUT_DIR/stats.txt | grep -i -E "system.cpu.dcache.overall_miss_rate::total|system.cpu.icache.overall_miss_rate::total|system.l2.overall_miss_rate::total" > $GREP_FILE
        printf "l1.icache.miss_penality \t\t\t 6\n" >> $GREP_FILE
        printf "l1.dcache.miss_penality \t\t\t 6\n" >> $GREP_FILE
        printf "l2.miss_penality \t\t\t\t 50\n" >> $GREP_FILE
        printf "system.cpi \t\t\t\t     $cpi \n" >> $GREP_FILE

        cat $GREP_FILE
}

runSimulation(){

# total input parameters = 8
#OUT_DIR=~/470/l2$4_$7/$8/l1i$3_$6_l1d$2_$5/

    if [ $# -ne 8 ]; then 
        echo "Missing parameters; Toal 8 parameters are needed"
        echo "Arguments passed - $*"
        exit 1
    fi 

    OUT_DIR=~/cache-results/470/l2-$4_$7/$8/inst-$3_$6_data-$2_$5
    GEM5_DIR=~/gem5/gem5
    BENCHMARK=./src/benchmark
    ARGUMENT=./data/inp.in
    echo "Output_dir - $OUT_DIR"
    mkdir -p $OUT_DIR
    command="time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o "$ARGUMENT" -I 500000000 --cpu-type=$1 --caches --l2cache --l1d_size=$2 --l1i_size=$3 --l2_size=$4 --l1d_assoc=$5 --l1i_assoc=$6 --l2_assoc=$7 --cacheline_size=$8"
    echo "$command"
    time $GEM5_DIR/build/X86/gem5.opt -d $OUT_DIR $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o "$ARGUMENT" -I 500000000 --cpu-type=$1 --caches --l2cache --l1d_size=$2 --l1i_size=$3 --l2_size=$4 --l1d_assoc=$5 --l1i_assoc=$6 --l2_assoc=$7 --cacheline_size=$8
    printf "\nCalculating CPI \n"
    
    #getStats "/Users/vignesh/Downloads/ca-project/results/bimode_results/m5out_458/btb_2048/global2048_choice2048"
    #getStats "./"
    getStats $OUT_DIR
    printf "\n\n"
}

echo "Starting script"

runSimulation "timing" "128kB" "128kB" "1MB" "2" "2" "2" "32"
#runSimulation "timing" "256kB" "128kB" "512MB" "4" "2" "4" "32"


echo "End of Script"
exit 0


