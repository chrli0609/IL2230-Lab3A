vlog -sv ../parallel_neuron.sv
vlog -sv ../relu.sv
vlog -sv ../saturator.sv
vlog -sv n_neuron_fsm.sv
vlog -sv n_weights_memory.sv
vlog -sv n_neuron_mlp.sv
vlog -sv n_neuron_mlp_tb.sv


vsim work.n_neuron_mlp_tb -voptargs=+acc -debugDB

add wave -position insertpoint \
sim:/fsmd_tb/clk \
sim:/fsmd_tb/rstn \
sim:/fsmd_tb/soc \
sim:/fsmd_tb/in \
sim:/fsmd_tb/bias \
sim:/fsmd_tb/out \
sim:/fsmd_tb/eoc

run 300ns
