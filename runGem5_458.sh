# -- an example to run SPEC 458.sjeng on gem5, put it under 458.sjeng folder --
export GEM5_DIR=/home/johnj/gem5
export BENCHMARK=/home/johnj/gem5/m5out/benchmarks/458.sjeng/src/benchmark
export ARGUMENT=/home/johnj/gem5/m5out/benchmarks/458.sjeng/data/test.txt
time $GEM5_DIR/build/X86/gem5.opt -d /home/johnj/gem5/m5out/benchmarks/458.sjeng/m5out $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 1000 --cpu-type=TimingSimpleCPU --caches --l2cache --l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
