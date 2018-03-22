vlib work

vlog -timescale 1ns/1ns obstacledodger.v control.v datapath.v

vsim obstacledodger

log {/*}

add wave {/*}
add wave -position insertpoint sim:/obstacledodger/d1/*
add wave -position insertpoint sim:/obstacledodger/d1/f1/*
add wave -position insertpoint sim:/obstacledodger/d1/d1/*
add wave -position insertpoint sim:/obstacledodger/c1/*

force {KEY[0]} 0 0, 1 25
force {CLOCK_50} 0 0, 1 1 -r 2

force {KEY[1]} 0 0, 1 120, 0 150
#force {clock} 0 0, 1 1 -r 2
#force {resetn} 0 0, 1 20
#force {finish} 0 0
#force {ld} 0 0, 1 50, 0 100

run 4000