# -- an example to run SPEC 470.lbm on gem5, put it under 470.lbm folder --
export GEM5_DIR=~/gem5
export BENCHMARK=~/gem5/m5out/benchmarks/470.lbm/src/benchmark
#export ARGUMENT= 20 reference.dat 0 1  /home/johnj/gem5/m5out/benchmarks/470.lbm/data/100_100_130_cf_a.of
time $GEM5_DIR/build/X86/gem5.opt -d ~/gem5/m5out/benchmarks/470.lbm/m5out $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o "20 reference.dat 0 1 /home/johnj/gem5/m5out/benchmarks/470.lbm/data/100_100_130_cf_a.of" -I 500000000 --cpu-type=TimingSimpleCPU --caches --l2cache --l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
