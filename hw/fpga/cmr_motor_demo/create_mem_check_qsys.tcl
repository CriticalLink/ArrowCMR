# qsys scripting (.tcl) file for mem_check
package require -exact qsys 18.1

create_system {mem_check}

set_project_property DEVICE_FAMILY {Cyclone V}
set_project_property DEVICE {5CSXFC6C6U23C7}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance check altera_avalon_data_pattern_checker 18.1
set_instance_parameter_value check {AVALON_ENABLED} {1}
set_instance_parameter_value check {BYPASS_ENABLED} {0}
set_instance_parameter_value check {CROSS_CLK_SYNC_DEPTH} {2}
set_instance_parameter_value check {FREQ_CNTER_ENABLED} {0}
set_instance_parameter_value check {NUM_CYCLES_FOR_LOCK} {40}
set_instance_parameter_value check {ST_DATA_W} {128}

add_instance csr altera_avalon_mm_bridge 18.1
set_instance_parameter_value csr {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value csr {ADDRESS_WIDTH} {10}
set_instance_parameter_value csr {DATA_WIDTH} {32}
set_instance_parameter_value csr {LINEWRAPBURSTS} {0}
set_instance_parameter_value csr {MAX_BURST_SIZE} {1}
set_instance_parameter_value csr {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value csr {PIPELINE_COMMAND} {1}
set_instance_parameter_value csr {PIPELINE_RESPONSE} {1}
set_instance_parameter_value csr {SYMBOL_WIDTH} {8}
set_instance_parameter_value csr {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value csr {USE_RESPONSE} {0}

add_instance csr2data_clock_cross altera_avalon_mm_clock_crossing_bridge 18.1
set_instance_parameter_value csr2data_clock_cross {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value csr2data_clock_cross {ADDRESS_WIDTH} {10}
set_instance_parameter_value csr2data_clock_cross {COMMAND_FIFO_DEPTH} {4}
set_instance_parameter_value csr2data_clock_cross {DATA_WIDTH} {32}
set_instance_parameter_value csr2data_clock_cross {MASTER_SYNC_DEPTH} {2}
set_instance_parameter_value csr2data_clock_cross {MAX_BURST_SIZE} {1}
set_instance_parameter_value csr2data_clock_cross {RESPONSE_FIFO_DEPTH} {4}
set_instance_parameter_value csr2data_clock_cross {SLAVE_SYNC_DEPTH} {2}
set_instance_parameter_value csr2data_clock_cross {SYMBOL_WIDTH} {8}
set_instance_parameter_value csr2data_clock_cross {USE_AUTO_ADDRESS_WIDTH} {1}

add_instance csr_clk altera_clock_bridge 18.1
set_instance_parameter_value csr_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value csr_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance data_clk altera_clock_bridge 18.1
set_instance_parameter_value data_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value data_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance gen altera_avalon_data_pattern_generator 18.1
set_instance_parameter_value gen {AVALON_ENABLED} {1}
set_instance_parameter_value gen {BYPASS_ENABLED} {0}
set_instance_parameter_value gen {CROSS_CLK_SYNC_DEPTH} {2}
set_instance_parameter_value gen {FREQ_CNTER_ENABLED} {0}
set_instance_parameter_value gen {ST_DATA_W} {128}

add_instance mem altera_avalon_mm_bridge 18.1
set_instance_parameter_value mem {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value mem {ADDRESS_WIDTH} {10}
set_instance_parameter_value mem {DATA_WIDTH} {128}
set_instance_parameter_value mem {LINEWRAPBURSTS} {0}
set_instance_parameter_value mem {MAX_BURST_SIZE} {64}
set_instance_parameter_value mem {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value mem {PIPELINE_COMMAND} {1}
set_instance_parameter_value mem {PIPELINE_RESPONSE} {1}
set_instance_parameter_value mem {SYMBOL_WIDTH} {8}
set_instance_parameter_value mem {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value mem {USE_RESPONSE} {0}

add_instance rd dma_read_master 18.1
set_instance_parameter_value rd {BURST_ENABLE} {1}
set_instance_parameter_value rd {CHANNEL_ENABLE} {0}
set_instance_parameter_value rd {CHANNEL_WIDTH} {8}
set_instance_parameter_value rd {DATA_WIDTH} {128}
set_instance_parameter_value rd {ERROR_ENABLE} {0}
set_instance_parameter_value rd {ERROR_WIDTH} {8}
set_instance_parameter_value rd {FIFO_DEPTH} {1024}
set_instance_parameter_value rd {FIFO_SPEED_OPTIMIZATION} {1}
set_instance_parameter_value rd {FIX_ADDRESS_WIDTH} {32}
set_instance_parameter_value rd {GUI_BURST_WRAPPING_SUPPORT} {1}
set_instance_parameter_value rd {GUI_MAX_BURST_COUNT} {32}
set_instance_parameter_value rd {GUI_PROGRAMMABLE_BURST_ENABLE} {0}
set_instance_parameter_value rd {GUI_STRIDE_WIDTH} {1}
set_instance_parameter_value rd {LENGTH_WIDTH} {32}
set_instance_parameter_value rd {PACKET_ENABLE} {0}
set_instance_parameter_value rd {STRIDE_ENABLE} {0}
set_instance_parameter_value rd {TRANSFER_TYPE} {Aligned Accesses}
set_instance_parameter_value rd {USE_FIX_ADDRESS_WIDTH} {1}

add_instance rd_dis modular_sgdma_dispatcher 18.1
set_instance_parameter_value rd_dis {BURST_ENABLE} {0}
set_instance_parameter_value rd_dis {BURST_WRAPPING_SUPPORT} {0}
set_instance_parameter_value rd_dis {CSR_ADDRESS_WIDTH} {3}
set_instance_parameter_value rd_dis {DATA_FIFO_DEPTH} {32}
set_instance_parameter_value rd_dis {DATA_WIDTH} {32}
set_instance_parameter_value rd_dis {DESCRIPTOR_FIFO_DEPTH} {128}
set_instance_parameter_value rd_dis {ENHANCED_FEATURES} {1}
set_instance_parameter_value rd_dis {GUI_RESPONSE_PORT} {2}
set_instance_parameter_value rd_dis {MAX_BURST_COUNT} {2}
set_instance_parameter_value rd_dis {MAX_BYTE} {1024}
set_instance_parameter_value rd_dis {MAX_STRIDE} {1}
set_instance_parameter_value rd_dis {MODE} {1}
set_instance_parameter_value rd_dis {PREFETCHER_USE_CASE} {0}
set_instance_parameter_value rd_dis {PROGRAMMABLE_BURST_ENABLE} {0}
set_instance_parameter_value rd_dis {STRIDE_ENABLE} {0}
set_instance_parameter_value rd_dis {TRANSFER_TYPE} {Aligned Accesses}

add_instance rst altera_reset_bridge 18.1
set_instance_parameter_value rst {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value rst {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value rst {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value rst {USE_RESET_REQUEST} {0}

add_instance wr dma_write_master 18.1
set_instance_parameter_value wr {BURST_ENABLE} {1}
set_instance_parameter_value wr {DATA_WIDTH} {128}
set_instance_parameter_value wr {ERROR_ENABLE} {0}
set_instance_parameter_value wr {ERROR_WIDTH} {8}
set_instance_parameter_value wr {FIFO_DEPTH} {1024}
set_instance_parameter_value wr {FIFO_SPEED_OPTIMIZATION} {1}
set_instance_parameter_value wr {FIX_ADDRESS_WIDTH} {32}
set_instance_parameter_value wr {GUI_BURST_WRAPPING_SUPPORT} {1}
set_instance_parameter_value wr {GUI_MAX_BURST_COUNT} {32}
set_instance_parameter_value wr {GUI_PROGRAMMABLE_BURST_ENABLE} {0}
set_instance_parameter_value wr {GUI_STRIDE_WIDTH} {1}
set_instance_parameter_value wr {LENGTH_WIDTH} {32}
set_instance_parameter_value wr {PACKET_ENABLE} {0}
set_instance_parameter_value wr {STRIDE_ENABLE} {0}
set_instance_parameter_value wr {TRANSFER_TYPE} {Aligned Accesses}
set_instance_parameter_value wr {USE_FIX_ADDRESS_WIDTH} {0}

add_instance wr_dis modular_sgdma_dispatcher 18.1
set_instance_parameter_value wr_dis {BURST_ENABLE} {0}
set_instance_parameter_value wr_dis {BURST_WRAPPING_SUPPORT} {0}
set_instance_parameter_value wr_dis {CSR_ADDRESS_WIDTH} {3}
set_instance_parameter_value wr_dis {DATA_FIFO_DEPTH} {32}
set_instance_parameter_value wr_dis {DATA_WIDTH} {32}
set_instance_parameter_value wr_dis {DESCRIPTOR_FIFO_DEPTH} {128}
set_instance_parameter_value wr_dis {ENHANCED_FEATURES} {1}
set_instance_parameter_value wr_dis {GUI_RESPONSE_PORT} {2}
set_instance_parameter_value wr_dis {MAX_BURST_COUNT} {2}
set_instance_parameter_value wr_dis {MAX_BYTE} {1024}
set_instance_parameter_value wr_dis {MAX_STRIDE} {1}
set_instance_parameter_value wr_dis {MODE} {2}
set_instance_parameter_value wr_dis {PREFETCHER_USE_CASE} {0}
set_instance_parameter_value wr_dis {PROGRAMMABLE_BURST_ENABLE} {0}
set_instance_parameter_value wr_dis {STRIDE_ENABLE} {0}
set_instance_parameter_value wr_dis {TRANSFER_TYPE} {Aligned Accesses}

# exported interfaces
add_interface csr_clk_in_clk clock sink
set_interface_property csr_clk_in_clk EXPORT_OF csr_clk.in_clk
add_interface csr_s0 avalon slave
set_interface_property csr_s0 EXPORT_OF csr.s0
add_interface data_clk_in_clk clock sink
set_interface_property data_clk_in_clk EXPORT_OF data_clk.in_clk
add_interface mem_m0 avalon master
set_interface_property mem_m0 EXPORT_OF mem.m0
add_interface reset reset sink
set_interface_property reset EXPORT_OF rst.in_reset

# connections and connection parameters
add_connection csr.m0 check.csr_slave
set_connection_parameter_value csr.m0/check.csr_slave arbitrationPriority {1}
set_connection_parameter_value csr.m0/check.csr_slave baseAddress {0x4000}
set_connection_parameter_value csr.m0/check.csr_slave defaultConnection {0}

add_connection csr.m0 csr2data_clock_cross.s0
set_connection_parameter_value csr.m0/csr2data_clock_cross.s0 arbitrationPriority {1}
set_connection_parameter_value csr.m0/csr2data_clock_cross.s0 baseAddress {0x0000}
set_connection_parameter_value csr.m0/csr2data_clock_cross.s0 defaultConnection {0}

add_connection csr.m0 gen.csr_slave
set_connection_parameter_value csr.m0/gen.csr_slave arbitrationPriority {1}
set_connection_parameter_value csr.m0/gen.csr_slave baseAddress {0x8000}
set_connection_parameter_value csr.m0/gen.csr_slave defaultConnection {0}

add_connection csr2data_clock_cross.m0 rd_dis.CSR
set_connection_parameter_value csr2data_clock_cross.m0/rd_dis.CSR arbitrationPriority {1}
set_connection_parameter_value csr2data_clock_cross.m0/rd_dis.CSR baseAddress {0x0020}
set_connection_parameter_value csr2data_clock_cross.m0/rd_dis.CSR defaultConnection {0}

add_connection csr2data_clock_cross.m0 rd_dis.Descriptor_Slave
set_connection_parameter_value csr2data_clock_cross.m0/rd_dis.Descriptor_Slave arbitrationPriority {1}
set_connection_parameter_value csr2data_clock_cross.m0/rd_dis.Descriptor_Slave baseAddress {0x0000}
set_connection_parameter_value csr2data_clock_cross.m0/rd_dis.Descriptor_Slave defaultConnection {0}

add_connection csr2data_clock_cross.m0 wr_dis.CSR
set_connection_parameter_value csr2data_clock_cross.m0/wr_dis.CSR arbitrationPriority {1}
set_connection_parameter_value csr2data_clock_cross.m0/wr_dis.CSR baseAddress {0x0060}
set_connection_parameter_value csr2data_clock_cross.m0/wr_dis.CSR defaultConnection {0}

add_connection csr2data_clock_cross.m0 wr_dis.Descriptor_Slave
set_connection_parameter_value csr2data_clock_cross.m0/wr_dis.Descriptor_Slave arbitrationPriority {1}
set_connection_parameter_value csr2data_clock_cross.m0/wr_dis.Descriptor_Slave baseAddress {0x0040}
set_connection_parameter_value csr2data_clock_cross.m0/wr_dis.Descriptor_Slave defaultConnection {0}

add_connection csr_clk.out_clk check.csr_clk

add_connection csr_clk.out_clk csr.clk

add_connection csr_clk.out_clk csr2data_clock_cross.s0_clk

add_connection csr_clk.out_clk gen.csr_clk

add_connection csr_clk.out_clk rst.clk

add_connection data_clk.out_clk check.pattern_in_clk

add_connection data_clk.out_clk csr2data_clock_cross.m0_clk

add_connection data_clk.out_clk gen.pattern_out_clk

add_connection data_clk.out_clk mem.clk

add_connection data_clk.out_clk rd.Clock

add_connection data_clk.out_clk rd_dis.clock

add_connection data_clk.out_clk wr.Clock

add_connection data_clk.out_clk wr_dis.clock

add_connection gen.pattern_out wr.Data_Sink

add_connection rd.Data_Read_Master mem.s0
set_connection_parameter_value rd.Data_Read_Master/mem.s0 arbitrationPriority {1}
set_connection_parameter_value rd.Data_Read_Master/mem.s0 baseAddress {0x0000}
set_connection_parameter_value rd.Data_Read_Master/mem.s0 defaultConnection {0}

add_connection rd.Data_Source check.pattern_in

add_connection rd.Response_Source rd_dis.Read_Response_Sink

add_connection rd_dis.Read_Command_Source rd.Command_Sink

add_connection rst.out_reset check.reset

add_connection rst.out_reset csr.reset

add_connection rst.out_reset csr2data_clock_cross.m0_reset

add_connection rst.out_reset csr2data_clock_cross.s0_reset

add_connection rst.out_reset gen.reset

add_connection rst.out_reset mem.reset

add_connection rst.out_reset rd.Clock_reset

add_connection rst.out_reset rd_dis.clock_reset

add_connection rst.out_reset wr.Clock_reset

add_connection rst.out_reset wr_dis.clock_reset

add_connection wr.Data_Write_Master mem.s0
set_connection_parameter_value wr.Data_Write_Master/mem.s0 arbitrationPriority {1}
set_connection_parameter_value wr.Data_Write_Master/mem.s0 baseAddress {0x0000}
set_connection_parameter_value wr.Data_Write_Master/mem.s0 defaultConnection {0}

add_connection wr.Response_Source wr_dis.Write_Response_Sink

add_connection wr_dis.Write_Command_Source wr.Command_Sink

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {mem_check.qsys}
