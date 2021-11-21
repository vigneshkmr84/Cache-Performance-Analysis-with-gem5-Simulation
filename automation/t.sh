#!/bin/bash
# Author - Vignesh 


#l2.overall_misses::total
STATS_FILE=/Users/vignesh/Downloads/ca-project/results/bimode_results/m5out_458/btb_2048/global2048_choice2048/stats.txt

#dcache_miss=$(grep 'system.cpu.dcache.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')
#icache_miss=$(grep 'system.cpu.icache.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')

dcache_miss=$(cat $STATS_FILE | grep 'system.cpu.dcache.overall_miss_rate::total' | awk '{print $2}')
icache_miss=$(cat $STATS_FILE | grep 'system.cpu.icache.overall_miss_rate::total' | awk '{print $2}')
l2_miss=$(cat $STATS_FILE | grep 'system.l2.overall_miss_rate::total' | awk '{print $2}')
echo 
echo 
echo
echo "l1_dcache_miss = $dcache_miss"
echo "l1_icache_miss = $icache_miss"

echo "l2_miss = $l2_miss"

#cpi=`expr $dcache_miss + $icache_miss`
#cpi=`expr $cpi + 1` 
#echo "CPI - $cpi"

cpi=$(echo "scale = 4; 1 + ($dcache_miss + $icache_miss)*6 + $l2_miss*50 " | bc)

echo $cpi 

cpi1=$(echo "scale = 4; ($dcache_miss + $icache_miss)*6 " | bc)
cpi2=$(echo "scale = 4; $l2_miss*50 " | bc)
cpi=$(echo "scale = 4; 1 + $cpi1 + $cpi2 " | bc)


echo "CPI: $cpi" 
echo $# 

echo $@

echo "$dcache_miss, $icache_miss, $cpi" >> temp.csv


#~/cache-results/470/block-32/l2-1MB_2/inst-128kB_2_data-128kB_2

#~/cache-results/470/block-32/l2-1MB_2/output.csv 
