onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CLOCK -color Orange /cordic_tb/cordic_dut/clock
add wave -noupdate -expand -group OUT -format Analog-Step -height 74 -max 4094.0 -min 2.0 -radix decimal /cordic_tb/cordic_dut/sine
add wave -noupdate -expand -group OUT -format Analog-Step -height 74 -max 4094.0 -min 2.0 -radix decimal /cordic_tb/cordic_dut/cosine
add wave -noupdate -expand -group ANGLE -format Analog-Step -height 74 -max 3216.9999999999995 -radix unsigned /cordic_tb/cordic_dut/phase_controller_dut/phase
add wave -noupdate -expand -group ANGLE -radix unsigned /cordic_tb/cordic_dut/phase_controller_dut/quadrant
add wave -noupdate -expand -group ANGLE -format Analog-Step -height 74 -max 3216.9999999999995 -radix unsigned /cordic_tb/cordic_dut/phase_controller_dut/angle_counter
add wave -noupdate -expand -group {ROTATOR 0} -format Analog-Step -height 74 -max 1313.0 -min 1243.0 {/cordic_tb/cordic_dut/cordic_chain_dut/genblk1[0]/rotator_dut/x_out}
add wave -noupdate -expand -group {ROTATOR 1} -format Analog-Step -height 74 -max 1863.9999999999998 -min 622.0 {/cordic_tb/cordic_dut/cordic_chain_dut/genblk1[1]/rotator_dut/x_out}
add wave -noupdate -expand -group {ROTATOR 4} -format Analog-Step -height 74 -max 2044.0 -min 31.0 {/cordic_tb/cordic_dut/cordic_chain_dut/genblk1[4]/rotator_dut/y_out}
add wave -noupdate -expand -group {ROTATOR 9} -format Analog-Step -height 74 -max 2046.0000000000002 -min 4.0 {/cordic_tb/cordic_dut/cordic_chain_dut/genblk1[9]/rotator_dut/x_out}
TreeUpdate [SetDefaultTree]
quietly wave cursor active 1
configure wave -namecolwidth 472
configure wave -valuecolwidth 57
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update

