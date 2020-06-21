

create_clock -period 20.000 -name v_clk -waveform {0.000 10.000} -add
set_input_delay -clock [get_clocks *v_clk*] -add_delay 0.200 [get_ports -filter { NAME !~  "*clk*" && DIRECTION == "IN" }]
set_output_delay -clock [get_clocks *v_clk*] -add_delay 0.200 [get_ports -filter { NAME =~  "*" && DIRECTION == "OUT" }]





