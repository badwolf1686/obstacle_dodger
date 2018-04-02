vlib work

vlog -timescale 1ns/1ns datapath.v obs_datapath.v helper.v

vsim datapath

log {/*}

add wave {/*}
add wave -position insertpoint sim:/datapath/d1/*
add wave -position insertpoint sim:/datapath/f1/*
add wave -position insertpoint sim:/datapath/od0/*

force {clock} 0 0, 1 1 -r 2
force {resetn} 1 0, 0 10, 1 20
force {finish} 0 0
force {draw} 0 0, 1 150
force {setoff} 0 0, 1 150

run 8000
