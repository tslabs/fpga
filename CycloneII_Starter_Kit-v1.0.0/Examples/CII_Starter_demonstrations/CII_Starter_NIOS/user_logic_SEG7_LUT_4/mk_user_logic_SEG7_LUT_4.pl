






use strict;             # keeps us honest
use generator_library;  # includes all the code we'll need???








generator_enable_mode ("terse");





generator_begin (@ARGV);



generator_make_module_wrapper(1, "SEG7_LUT_4");



















generator_copy_files_and_set_system_ptf ("simulation_and_quartus", 
                ("SEG7_LUT.v","SEG7_LUT_4.v"));





generator_end ();





exit (0);

