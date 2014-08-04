//
// auto-generated by ops.py on 2014-07-31 12:58
//



#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#define OPS_3D
#include  "ops_lib_cpp.h"

//
// ops_par_loop declarations
//

void ops_par_loop_flux_calc_kernelx(char const *, ops_block, int , int*,
  ops_arg,
  ops_arg,
  ops_arg,
  ops_arg );

void ops_par_loop_flux_calc_kernely(char const *, ops_block, int , int*,
  ops_arg,
  ops_arg,
  ops_arg,
  ops_arg );

void ops_par_loop_flux_calc_kernelz(char const *, ops_block, int , int*,
  ops_arg,
  ops_arg,
  ops_arg,
  ops_arg );



#include "data.h"
#include "definitions.h"

//#include "flux_calc_kernel.h"

void flux_calc()
{
  error_condition = 0;

  int x_cells = grid.x_cells;
  int y_cells = grid.y_cells;
  int x_min = field.x_min;
  int x_max = field.x_max;
  int y_min = field.y_min;
  int y_max = field.y_max;
  int z_min = field.z_min;
  int z_max = field.z_max;

  int rangexyz_inner_plus1x[] = {x_min,x_max+1,y_min,y_max,z_min,z_max};

  ops_par_loop_flux_calc_kernelx("flux_calc_kernelx", clover_grid, 3, rangexyz_inner_plus1x,
               ops_arg_dat(vol_flux_x, S3D_000, "double", OPS_WRITE),
               ops_arg_dat(xarea, S3D_000, "double", OPS_READ),
               ops_arg_dat(xvel0, S3D_000_f0P1P1, "double", OPS_READ),
               ops_arg_dat(xvel1, S3D_000_f0P1P1, "double", OPS_READ));

  int rangexyz_inner_plus1y[] = {x_min,x_max,y_min,y_max+1,z_min,z_max};

  ops_par_loop_flux_calc_kernely("flux_calc_kernely", clover_grid, 3, rangexyz_inner_plus1y,
               ops_arg_dat(vol_flux_y, S3D_000, "double", OPS_WRITE),
               ops_arg_dat(yarea, S3D_000, "double", OPS_READ),
               ops_arg_dat(yvel0, S3D_000_fP10P1, "double", OPS_READ),
               ops_arg_dat(yvel1, S3D_000_fP10P1, "double", OPS_READ));

  int rangexyz_inner_plus1z[] = {x_min,x_max,y_min,y_max,z_min,z_max+1};

  ops_par_loop_flux_calc_kernelz("flux_calc_kernelz", clover_grid, 3, rangexyz_inner_plus1z,
               ops_arg_dat(vol_flux_z, S3D_000, "double", OPS_WRITE),
               ops_arg_dat(zarea, S3D_000, "double", OPS_READ),
               ops_arg_dat(zvel0, S3D_000_fP1P10, "double", OPS_READ),
               ops_arg_dat(zvel1, S3D_000_fP1P10, "double", OPS_READ));

}
