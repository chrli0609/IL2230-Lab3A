vlog -sv ../parallel_neuron.sv
vlog -sv ../relu.sv
vlog -sv ../saturator.sv
vlog -sv n_neuron_fsm.sv
vlog -sv n_weights_memory.sv
vlog -sv n_neuron_mlp.sv
vlog -sv n_neuron_mlp_tb.sv


vsim work.n_neuron_mlp_tb -voptargs=+acc -debugDB

add wave -position insertpoint \
sim:/n_neuron_mlp_tb/clk \
sim:/n_neuron_mlp_tb/rstn \
sim:/n_neuron_mlp_tb/soc \
sim:/n_neuron_mlp_tb/in \
sim:/n_neuron_mlp_tb/bias \
sim:/n_neuron_mlp_tb/out \
sim:/n_neuron_mlp_tb/eoc

run 300ns
