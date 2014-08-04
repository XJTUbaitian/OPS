//
// auto-generated by ops.py on 2014-07-31 12:58
//


#pragma OPENCL EXTENSION cl_khr_fp64:enable

#include "user_types.h"
#include "ops_opencl_reduction.h"

#ifndef MIN
#define MIN(a,b) ((a<b) ? (a) : (b))
#endif
#ifndef MAX
#define MAX(a,b) ((a>b) ? (a) : (b))
#endif
#ifndef SIGN
#define SIGN(a,b) ((b<0.0) ? (a*(-1)) : (a))
#endif
#define OPS_READ 0
#define OPS_WRITE 1
#define OPS_RW 2
#define OPS_INC 3
#define OPS_MIN 4
#define OPS_MAX 5
#define ZERO_double 0.0;
#define INFINITY_double INFINITY;
#define ZERO_float 0.0f;
#define INFINITY_float INFINITY;
#define ZERO_int 0;
#define INFINITY_int INFINITY;
#define ZERO_uint 0;
#define INFINITY_uint INFINITY;
#define ZERO_ll 0;
#define INFINITY_ll INFINITY;
#define ZERO_ull 0;
#define INFINITY_ull INFINITY;
#define ZERO_bool 0;
#define OPS_ACC0(x,y,z) (x+xdim0_advec_cell_kernel1_xdir*(y)+xdim0_advec_cell_kernel1_xdir*ydim0_advec_cell_kernel1_xdir*(z))
#define OPS_ACC1(x,y,z) (x+xdim1_advec_cell_kernel1_xdir*(y)+xdim1_advec_cell_kernel1_xdir*ydim1_advec_cell_kernel1_xdir*(z))
#define OPS_ACC2(x,y,z) (x+xdim2_advec_cell_kernel1_xdir*(y)+xdim2_advec_cell_kernel1_xdir*ydim2_advec_cell_kernel1_xdir*(z))
#define OPS_ACC3(x,y,z) (x+xdim3_advec_cell_kernel1_xdir*(y)+xdim3_advec_cell_kernel1_xdir*ydim3_advec_cell_kernel1_xdir*(z))
#define OPS_ACC4(x,y,z) (x+xdim4_advec_cell_kernel1_xdir*(y)+xdim4_advec_cell_kernel1_xdir*ydim4_advec_cell_kernel1_xdir*(z))
#define OPS_ACC5(x,y,z) (x+xdim5_advec_cell_kernel1_xdir*(y)+xdim5_advec_cell_kernel1_xdir*ydim5_advec_cell_kernel1_xdir*(z))


//user function
inline void advec_cell_kernel1_xdir( __global double * restrict pre_vol, __global double * restrict post_vol, const __global double * restrict volume, 
const __global double * restrict vol_flux_x, const __global double * restrict vol_flux_y, const __global double * restrict vol_flux_z)

  {

  pre_vol[OPS_ACC0(0,0,0)] = volume[OPS_ACC2(0,0,0)] +
                         ( vol_flux_x[OPS_ACC3(1,0,0)] - vol_flux_x[OPS_ACC3(0,0,0)] +
                           vol_flux_y[OPS_ACC4(0,1,0)] - vol_flux_y[OPS_ACC4(0,0,0)] +
                           vol_flux_z[OPS_ACC5(0,0,1)] - vol_flux_z[OPS_ACC5(0,0,0)]);
  post_vol[OPS_ACC1(0,0,0)] = pre_vol[OPS_ACC0(0,0,0)] - ( vol_flux_x[OPS_ACC3(1,0,0)] - vol_flux_x[OPS_ACC3(0,0,0)]);

}



 #undef OPS_ACC0
 #undef OPS_ACC1
 #undef OPS_ACC2
 #undef OPS_ACC3
 #undef OPS_ACC4
 #undef OPS_ACC5


 __kernel void ops_advec_cell_kernel1_xdir(
 __global double* restrict arg0,
 __global double* restrict arg1,
 __global const double* restrict arg2,
 __global const double* restrict arg3,
 __global const double* restrict arg4,
 __global const double* restrict arg5,
 const int base0,
 const int base1,
 const int base2,
 const int base3,
 const int base4,
 const int base5,
 const int size0,
 const int size1,
 const int size2 ){


   int idx_z = get_global_id(2);
   int idx_y = get_global_id(1);
   int idx_x = get_global_id(0);

   if (idx_x < size0 && idx_y < size1 && idx_z < size2) {
     advec_cell_kernel1_xdir(&arg0[base0 + idx_x * 1 + idx_y * 1 * xdim0_advec_cell_kernel1_xdir + idx_z * 1 * xdim0_advec_cell_kernel1_xdir * ydim0_advec_cell_kernel1_xdir],
                       &arg1[base1 + idx_x * 1 + idx_y * 1 * xdim1_advec_cell_kernel1_xdir + idx_z * 1 * xdim1_advec_cell_kernel1_xdir * ydim1_advec_cell_kernel1_xdir],
                       &arg2[base2 + idx_x * 1 + idx_y * 1 * xdim2_advec_cell_kernel1_xdir + idx_z * 1 * xdim2_advec_cell_kernel1_xdir * ydim2_advec_cell_kernel1_xdir],
                       &arg3[base3 + idx_x * 1 + idx_y * 1 * xdim3_advec_cell_kernel1_xdir + idx_z * 1 * xdim3_advec_cell_kernel1_xdir * ydim3_advec_cell_kernel1_xdir],
                       &arg4[base4 + idx_x * 1 + idx_y * 1 * xdim4_advec_cell_kernel1_xdir + idx_z * 1 * xdim4_advec_cell_kernel1_xdir * ydim4_advec_cell_kernel1_xdir],
                       &arg5[base5 + idx_x * 1 + idx_y * 1 * xdim5_advec_cell_kernel1_xdir + idx_z * 1 * xdim5_advec_cell_kernel1_xdir * ydim5_advec_cell_kernel1_xdir]);
   }

 }
