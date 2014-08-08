//
// auto-generated by ops.py on 2014-08-08 12:31
//


#ifdef OCL_FMA
#pragma OPENCL FP_CONTRACT ON
#else
#pragma OPENCL FP_CONTRACT OFF
#endif
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
#define OPS_ACC0(x,y) (x+xdim0_advec_mom_kernel_post_pre_advec_y*(y))
#define OPS_ACC1(x,y) (x+xdim1_advec_mom_kernel_post_pre_advec_y*(y))
#define OPS_ACC2(x,y) (x+xdim2_advec_mom_kernel_post_pre_advec_y*(y))
#define OPS_ACC3(x,y) (x+xdim3_advec_mom_kernel_post_pre_advec_y*(y))
#define OPS_ACC4(x,y) (x+xdim4_advec_mom_kernel_post_pre_advec_y*(y))


//user function
inline void advec_mom_kernel_post_pre_advec_y( __global double * restrict node_mass_post, const __global double * restrict post_vol, const __global double * restrict density1, 
__global double * restrict node_mass_pre, const __global double * restrict node_flux)

  {



  node_mass_post[OPS_ACC0(0,0)] = 0.25 * ( density1[OPS_ACC2(0,-1)] * post_vol[OPS_ACC1(0,-1)] +
                              density1[OPS_ACC2(0,0)]   * post_vol[OPS_ACC1(0,0)]   +
                              density1[OPS_ACC2(-1,-1)] * post_vol[OPS_ACC1(-1,-1)] +
                              density1[OPS_ACC2(-1,0)]  * post_vol[OPS_ACC1(-1,0)]  );

  node_mass_pre[OPS_ACC3(0,0)] = node_mass_post[OPS_ACC0(0,0)] - node_flux[OPS_ACC4(0,-1)] + node_flux[OPS_ACC4(0,0)];

}



 #undef OPS_ACC0
 #undef OPS_ACC1
 #undef OPS_ACC2
 #undef OPS_ACC3
 #undef OPS_ACC4


 __kernel void ops_advec_mom_kernel_post_pre_advec_y(
 __global double* restrict arg0,
 __global const double* restrict arg1,
 __global const double* restrict arg2,
 __global double* restrict arg3,
 __global const double* restrict arg4,
 const int base0,
 const int base1,
 const int base2,
 const int base3,
 const int base4,
 const int size0,
 const int size1 ){


   int idx_y = get_global_id(1);
   int idx_x = get_global_id(0);

   if (idx_x < size0 && idx_y < size1) {
     advec_mom_kernel_post_pre_advec_y(&arg0[base0 + idx_x * 1 + idx_y * 1 * xdim0_advec_mom_kernel_post_pre_advec_y],
                      &arg1[base1 + idx_x * 1 + idx_y * 1 * xdim1_advec_mom_kernel_post_pre_advec_y],
                      &arg2[base2 + idx_x * 1 + idx_y * 1 * xdim2_advec_mom_kernel_post_pre_advec_y],
                      &arg3[base3 + idx_x * 1 + idx_y * 1 * xdim3_advec_mom_kernel_post_pre_advec_y],
                      &arg4[base4 + idx_x * 1 + idx_y * 1 * xdim4_advec_mom_kernel_post_pre_advec_y]);
   }

 }
