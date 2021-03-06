vlib work

vlog -timescale 1ns/1ns obs_datapath.v helper.v

vsim obs_datapath

log {/*}

add wave {/*}
add wave -position insertpoint sim:/obs_datapath/r1/*
add wave -position insertpoint sim:/obs_datapath/d1/*
add wave -position insertpoint sim:/obs_datapath/f1/*

force {resetn} 1 0, 0 10, 1 25
force {clock} 0 0, 1 1 -r 2

force {draw} 0 0, 1 1200
#force {setoff} 0 0, 1 1500
#force {clock} 0 0, 1 1 -r 2
#force {resetn} 0 0, 1 20
#force {finish} 0 0
#force {ld} 0 0, 1 50, 0 100

run 8000
