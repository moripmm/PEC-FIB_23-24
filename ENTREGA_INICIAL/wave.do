quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group proc /test_sisa/SoC/SRAM_ADDR
add wave -noupdate -expand -group proc /test_sisa/SoC/SRAM_DQ
add wave -noupdate -expand -group proc /test_sisa/SoC/SRAM_UB_N
add wave -noupdate -expand -group proc /test_sisa/SoC/SRAM_LB_N
add wave -noupdate -expand -group proc /test_sisa/SoC/SRAM_CE_N
add wave -noupdate -expand -group proc /test_sisa/SoC/SRAM_OE_N
add wave -noupdate -expand -group proc /test_sisa/SoC/SRAM_WE_N
add wave -noupdate -expand -group proc /test_sisa/SoC/SW
add wave -noupdate -expand -group proc /test_sisa/SoC/clock_sig
add wave -noupdate -expand -group proc /test_sisa/SoC/boot_sig
add wave -noupdate -expand -group proc /test_sisa/SoC/rd_data_sig
add wave -noupdate -expand -group proc /test_sisa/SoC/word_byte_sig
add wave -noupdate -expand -group proc /test_sisa/SoC/wr_m_sig
add wave -noupdate -expand -group proc /test_sisa/SoC/addr_m_sig
add wave -noupdate -expand -group proc /test_sisa/SoC/data_wr_sig
add wave -noupdate -expand -group func /test_sisa/SoC/proc0/clk
add wave -noupdate -expand -group func /test_sisa/SoC/proc0/boot
add wave -noupdate -expand -group func /test_sisa/SoC/proc0/c0/m0/estat
add wave -noupdate -expand -group func /test_sisa/SoC/proc0/c0/pc
add wave -noupdate -expand -group func /test_sisa/SoC/proc0/c0/ir_s
add wave -noupdate -expand -group func /test_sisa/SoC/proc0/c0/new_pc
add wave -noupdate -expand -group func /test_sisa/SoC/proc0/c0/new_ir
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/addr
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/wr_data
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/rd_data
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/we
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/byte_m
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/SRAM_ADDR
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/SRAM_DQ
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/SRAM_UB_N
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/SRAM_LB_N
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/SRAM_CE_N
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/SRAM_OE_N
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/SRAM_WE_N
add wave -noupdate -group Mem_ctrl /test_sisa/SoC/mem_controller0/we2
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/clk
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/SRAM_ADDR
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/SRAM_DQ
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/SRAM_UB_N
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/SRAM_LB_N
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/SRAM_CE_N
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/SRAM_OE_N
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/SRAM_WE_N
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/address
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/dataReaded
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/dataToWrite
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/WR
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/byte_m
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/estat
add wave -noupdate -group SRAM /test_sisa/SoC/mem_controller0/sram/wait1
add wave -noupdate -group BR /test_sisa/SoC/proc0/e0/reg0/wrd
add wave -noupdate -group BR /test_sisa/SoC/proc0/e0/reg0/d
add wave -noupdate -group BR /test_sisa/SoC/proc0/e0/reg0/addr_a
add wave -noupdate -group BR /test_sisa/SoC/proc0/e0/reg0/addr_b
add wave -noupdate -group BR /test_sisa/SoC/proc0/e0/reg0/addr_d
add wave -noupdate -group BR /test_sisa/SoC/proc0/e0/reg0/a
add wave -noupdate -group BR /test_sisa/SoC/proc0/e0/reg0/b
add wave -noupdate -group BR /test_sisa/SoC/proc0/e0/reg0/registre
add wave -noupdate -group Alu /test_sisa/SoC/proc0/e0/alu0/x
add wave -noupdate -group Alu /test_sisa/SoC/proc0/e0/alu0/y
add wave -noupdate -group Alu /test_sisa/SoC/proc0/e0/alu0/op
add wave -noupdate -group Alu /test_sisa/SoC/proc0/e0/alu0/w
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/op
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/wrd
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/addr_a
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/addr_b
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/addr_d
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/immed
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/immed_x2
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/datard_m
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/ins_dad
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/pc
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/in_d
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/addr_m
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/data_wr
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/a
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/b
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/alu_result
add wave -noupdate -group Datapath /test_sisa/SoC/proc0/e0/d
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/ir
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/op
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/ldpc
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/wrd
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/addr_a
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/addr_b
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/addr_d
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/immed
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/wr_m
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/in_d
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/immed_x2
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/word_byte
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/code_op
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/immed_tmp_h5
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/immed_tmp_l5
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/immed_tmp_h7
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/immed_tmp_l7
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/immed5
add wave -noupdate -group Control_logic /test_sisa/SoC/proc0/c0/c0/immed7
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/boot
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/ldpc_l
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/wrd_l
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/wr_m_l
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/w_b
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/ldpc
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/wrd
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/wr_m
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/ldir
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/ins_dad
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/word_byte
add wave -noupdate -group Multi /test_sisa/SoC/proc0/c0/m0/estat
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {112169 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {586984 ps}
