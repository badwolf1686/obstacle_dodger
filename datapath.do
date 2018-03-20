vlib work

vlog -timescale 1ns/1ns datapath.v

vsim datapath

log {/*}

add wave {/*}

force {resetn]} 0 0, 1 25
force {clock} 0 0, 1 1 -r 2

force {start} 0 0, 1 120, 0 150
force {draw} 0 0, 1 120, 0 150

run 4000
