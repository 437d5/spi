vlog -sv -mfcu +initmem+0 \
    ../rtl/*.sv           \
    ./src/*.sv            \

vsim -voptargs="+acc" work.top_tb