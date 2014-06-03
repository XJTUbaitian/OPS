//
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
// auto-generated by ops.py on 2014-06-17 17:28
=======
// auto-generated by ops.py on 2014-05-08 10:28
>>>>>>> 03fb03d... viscosity kernel running with opencl
=======
// auto-generated by ops.py on 2014-05-12 13:11
>>>>>>> 01b5ecc... Generating OpenCL master kernels file
=======
// auto-generated by ops.py on 2014-05-13 14:45
>>>>>>> 57308c8... Addign ideal_gas and flux_calc to opencl
=======
// auto-generated by ops.py on 2014-05-13 15:00
>>>>>>> 45be066... addign advec_mom to OpenCL
=======
// auto-generated by ops.py on 2014-05-13 15:30
>>>>>>> 2dd8a20... testing OpenCL with currently converted kernels
=======
// auto-generated by ops.py on 2014-05-14 15:27
>>>>>>> fcc5de7... Attempting to upload global constants, but these need to be uploaded every time
=======
// auto-generated by ops.py on 2014-05-15 16:56
>>>>>>> 7f143a4... working OpenCL with all non-reduction kernels and without Update halo
=======
// auto-generated by ops.py on 2014-05-15 17:08
>>>>>>> ceca208... Attempting to setup update halo kernel to OpenCL .. need to fix reductions
=======
// auto-generated by ops.py on 2014-05-28 15:13
>>>>>>> 033d7a0... Attempting to add calc_dt global reductions to OpenCL
=======
// auto-generated by ops.py on 2014-06-02 12:10
>>>>>>> ad432fc... Code generating global reductions
=======
// auto-generated by ops.py on 2014-06-02 12:26
>>>>>>> aee5038... Codegen working for reductions except for the __global key word issue in user kernel
=======
// auto-generated by ops.py on 2014-06-02 14:07
>>>>>>> 24690b8... Fixed user kernel parsing for __global
=======
// auto-generated by ops.py on 2014-06-02 16:13
>>>>>>> 496889f... Adding update halo kernel to Opencl - performance had gotten worse
=======
// auto-generated by ops.py on 2014-06-03 12:34
>>>>>>> ea30500... Setting up compilation that works for both CPUs and NVIDIA GPUs
=======
// auto-generated by ops.py on 2014-06-03 13:36
>>>>>>> 16b8dff... Fixing parse error in user kernel argument parsing
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>


#include  "ops_lib_cpp.h"

//
// ops_par_loop declarations
//

void ops_par_loop_ideal_gas_kernel(char const *, ops_block, int , int*,
  ops_arg,
  ops_arg,
  ops_arg,
  ops_arg );



#include "data.h"
#include "definitions.h"

//#include "ideal_gas_kernel.h"

void ideal_gas(int predict)
{

  int x_cells = grid.x_cells;
  int y_cells = grid.y_cells;
  int x_min = field.x_min;
  int x_max = field.x_max;
  int y_min = field.y_min;
  int y_max = field.y_max;

  int rangexy_inner[] = {x_min,x_max,y_min,y_max};

  if(predict != TRUE) {
    ops_par_loop_ideal_gas_kernel("ideal_gas_kernel", clover_grid, 2, rangexy_inner,
                 ops_arg_dat(density0, S2D_00, "double", OPS_READ),
                 ops_arg_dat(energy0, S2D_00, "double", OPS_READ),
                 ops_arg_dat(pressure, S2D_00, "double", OPS_WRITE),
                 ops_arg_dat(soundspeed, S2D_00, "double", OPS_WRITE));
  }
  else {
    ops_par_loop_ideal_gas_kernel("ideal_gas_kernel", clover_grid, 2, rangexy_inner,
                 ops_arg_dat(density1, S2D_00, "double", OPS_READ),
                 ops_arg_dat(energy1, S2D_00, "double", OPS_READ),
                 ops_arg_dat(pressure, S2D_00, "double", OPS_WRITE),
                 ops_arg_dat(soundspeed, S2D_00, "double", OPS_WRITE));
  }
}
