#!/bin/bash
# Author - Vignesh 


#l2.overall_misses::total
STATS_FILE=/Users/vignesh/Downloads/ca-project/results/bimode_results/m5out_458/btb_2048/global2048_choice2048/stats.txt

#dcache_miss=$(grep 'system.cpu.dcache.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')
#icache_miss=$(grep 'system.cpu.icache.overall_miss_rate::total' $STATS_FILE | awk '{print $2}')

dcache_miss=$(cat $STATS_FILE | grep 'system.cpu.dcache.overall_miss_rate::total' | awk '{print $2}')
l1d_access=$( cat $STATS_FILE | grep 'system.cpu.dcache.overall_accesses::total' | awk '{print $2}')

icache_miss=$(cat $STATS_FILE | grep 'system.cpu.icache.overall_miss_rate::total' | awk '{print $2}')
l1i_access=$( cat $STATS_FILE | grep 'system.cpu.icache.overall_accesses::total' | awk '{print $2}')

l2_miss=$(cat $STATS_FILE | grep 'system.l2.overall_miss_rate::total' | awk '{print $2}')
l2_access=$(cat $STATS_FILE | grep  'system.l2.overall_accesses::total' | awk '{print $2}')

echo "l1_dcache_miss = $dcache_miss; l1_d_access = $l1d_access"
echo "l1_icache_miss = $icache_miss; l1_i_access= $l1i_access"

echo "l2_miss = $l2_miss; l2_access=$l2_access"

#cpi=`expr $dcache_miss + $icache_miss`
#cpi=`expr $cpi + 1` 
#echo "CPI - $cpi"

cpi=$(echo "scale = 8; 1 + (($dcache_miss*$l1d_access + $icache_miss * $l1i_access)*6 + $l2_miss*$l2_access*50 )/500000000" | bc)

echo "CPI: $cpi" 
echo $# 

echo $@

echo "$dcache_miss, $icache_miss, $cpi" >> temp.csv


#~/cache-results/470/block-32/l2-1MB_2/inst-128kB_2_data-128kB_2

#~/cache-results/470/block-32/l2-1MB_2/output.csv 
