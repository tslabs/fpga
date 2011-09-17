






use strict;             # keeps us honest
use generator_library;  # includes all the code we'll need???








generator_enable_mode ("terse");





generator_begin (@ARGV);



generator_make_module_wrapper(1, "SRAM_16Bit_512K");



















generator_copy_files_and_set_system_ptf ("simulation_and_quartus", 
                ("SRAM_16Bit_512K.v"));





generator_end ();





exit (0);

