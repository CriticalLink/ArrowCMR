# to use this script, 
# example command to execute this script file
#   tclsh create_dev_5cs_top.tcl

# --- alternatively, input arguments could be passed in to select other design variant. 
#    EXPANDEDIO        : enable expanded I/O in place of FPGA DDR
#                        1 = enable, or
#                        0 = disable
#    HPS_DDR_D_SIZE    : size of HPS DDR D
#    HPS_DDR_A_SIZE    : size of HPS DDR A
#    HPS_DDR_NUM_CHIPS : number of HPS DDR chips
#    FPGA_DDR_A_SIZE   : size of FPGA DDR A

source $::env(QUARTUS_ROOTDIR)/../ip/altera/common/hw_tcl_packages/altera_terp.tcl

#package require altera_terp

proc show_cmd_args {} {
  global DEVICE_TYPE
  global EXPANDEDIO
  global HPS_DDR_D_SIZE
  global HPS_DDR_A_SIZE
  global HPS_DDR_NUM_CHIPS
  global FPGA_DDR_A_SIZE

  foreach {name val} $::argv {
    if {$name == "DEVICE_TYPE"} {
      set DEVICE_TYPE $val
    } elseif {$name == "EXPANDEDIO"} {
      set EXPANDEDIO $val
    } elseif {$name == "HPS_DDR_D_SIZE"} {
      set HPS_DDR_D_SIZE $val
    } elseif {$name == "HPS_DDR_A_SIZE"} {
      set HPS_DDR_A_SIZE $val
    } elseif {$name == "HPS_DDR_NUM_CHIPS"} {
      set HPS_DDR_NUM_CHIPS $val
    } elseif {$name == "FPGA_DDR_A_SIZE"} {
      set FPGA_DDR_A_SIZE $val
    } else {
      puts "-> Rejected parameter: $name,  \tValue: $val"
      continue
    }
    
    puts "-> Accepted parameter: $name,  \tValue: $val"
  }
}
show_cmd_args


# path to the TERP template
set template_path "dev_5cs_top.vhd.terp"
# file handle for template
set template_fh [open $template_path]
# template contents
set template   [read $template_fh]
# we are done with the file so we should close it
close $template_fh

# construct parameters value used in terp file
set param(EXPANDEDIO)             $EXPANDEDIO
set param(HPS_DDR_D_SIZE)         $HPS_DDR_D_SIZE
set param(HPS_DDR_A_SIZE)         $HPS_DDR_A_SIZE
set param(HPS_DDR_NUM_CHIPS)      $HPS_DDR_NUM_CHIPS
set param(FPGA_DDR_A_SIZE)        $FPGA_DDR_A_SIZE

set content [altera_terp $template param]
set fo [open "dev_5cs_top.vhd" "w"]
puts $fo $content
close $fo

