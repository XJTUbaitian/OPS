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
#define OPS_ACC0(x,y) (x+xdim0_accelerate_kernel*(y))
#define OPS_ACC1(x,y) (x+xdim1_accelerate_kernel*(y))
#define OPS_ACC2(x,y) (x+xdim2_accelerate_kernel*(y))
#define OPS_ACC3(x,y) (x+xdim3_accelerate_kernel*(y))
#define OPS_ACC4(x,y) (x+xdim4_accelerate_kernel*(y))
#define OPS_ACC5(x,y) (x+xdim5_accelerate_kernel*(y))
#define OPS_ACC6(x,y) (x+xdim6_accelerate_kernel*(y))
#define OPS_ACC7(x,y) (x+xdim7_accelerate_kernel*(y))
#define OPS_ACC8(x,y) (x+xdim8_accelerate_kernel*(y))
#define OPS_ACC9(x,y) (x+xdim9_accelerate_kernel*(y))
#define OPS_ACC10(x,y) (x+xdim10_accelerate_kernel*(y))


//user function
void accelerate_kernel( const __global double * restrict density0, const __global double * restrict volume, __global double * restrict stepbymass, 
const __global double * restrict xvel0, __global double * restrict xvel1, const __global double * restrict xarea, const __global double * restrict pressure, 
const __global double * restrict yvel0, __global double * restrict yvel1, const __global double * restrict yarea, const __global double * restrict viscosity, 

  const double dt)

  {

  double nodal_mass;

  nodal_mass = ( density0[OPS_ACC0(-1,-1)] * volume[OPS_ACC1(-1,-1)]
    + density0[OPS_ACC0(0,-1)] * volume[OPS_ACC1(0,-1)]
    + density0[OPS_ACC0(0,0)] * volume[OPS_ACC1(0,0)]
    + density0[OPS_ACC0(-1,0)] * volume[OPS_ACC1(-1,0)] ) * 0.25;

  stepbymass[OPS_ACC2(0,0)] = 0.5*dt/ nodal_mass;



  xvel1[OPS_ACC4(0,0)] = xvel0[OPS_ACC3(0,0)] - stepbymass[OPS_ACC2(0,0)] *
            ( xarea[OPS_ACC5(0,0)]  * ( pressure[OPS_ACC6(0,0)] - pressure[OPS_ACC6(-1,0)] ) +
              xarea[OPS_ACC5(0,-1)] * ( pressure[OPS_ACC6(0,-1)] - pressure[OPS_ACC6(-1,-1)] ) );



  yvel1[OPS_ACC8(0,0)] = yvel0[OPS_ACC7(0,0)] - stepbymass[OPS_ACC2(0,0)] *
            ( yarea[OPS_ACC9(0,0)]  * ( pressure[OPS_ACC6(0,0)] - pressure[OPS_ACC6(0,-1)] ) +
              yarea[OPS_ACC9(-1,0)] * ( pressure[OPS_ACC6(-1,0)] - pressure[OPS_ACC6(-1,-1)] ) );



  xvel1[OPS_ACC4(0,0)] = xvel1[OPS_ACC4(0,0)] - stepbymass[OPS_ACC2(0,0)] *
            ( xarea[OPS_ACC5(0,0)] * ( viscosity[OPS_ACC10(0,0)] - viscosity[OPS_ACC10(-1,0)] ) +
              xarea[OPS_ACC5(0,-1)] * ( viscosity[OPS_ACC10(0,-1)] - viscosity[OPS_ACC10(-1,-1)] ) );



  yvel1[OPS_ACC8(0,0)] = yvel1[OPS_ACC8(0,0)] - stepbymass[OPS_ACC2(0,0)] *
            ( yarea[OPS_ACC9(0,0)] * ( viscosity[OPS_ACC10(0,0)] - viscosity[OPS_ACC10(0,-1)] ) +
              yarea[OPS_ACC9(-1,0)] * ( viscosity[OPS_ACC10(-1,0)] - viscosity[OPS_ACC10(-1,-1)] ) );

}



 #undef OPS_ACC0
 #undef OPS_ACC1
 #undef OPS_ACC2
 #undef OPS_ACC3
 #undef OPS_ACC4
 #undef OPS_ACC5
 #undef OPS_ACC6
 #undef OPS_ACC7
 #undef OPS_ACC8
 #undef OPS_ACC9
 #undef OPS_ACC10


 __kernel void ops_accelerate_kernel(
 __global const double* restrict arg0,
 __global const double* restrict arg1,
 __global double* restrict arg2,
 __global const double* restrict arg3,
 __global double* restrict arg4,
 __global const double* restrict arg5,
 __global const double* restrict arg6,
 __global const double* restrict arg7,
 __global double* restrict arg8,
 __global const double* restrict arg9,
 __global const double* restrict arg10,
 const double dt,
 const int base0,
 const int base1,
 const int base2,
 const int base3,
 const int base4,
 const int base5,
 const int base6,
 const int base7,
 const int base8,
 const int base9,
 const int base10,
 const int size0,
 const int size1 ){


   int idx_y = get_global_id(1);
   int idx_x = get_global_id(0);

   if (idx_x < size0 && idx_y < size1) {
     accelerate_kernel(&arg0[base0 + idx_x * 1 + idx_y * 1 * xdim0_accelerate_kernel],
                       &arg1[base1 + idx_x * 1 + idx_y * 1 * xdim1_accelerate_kernel],
                       &arg2[base2 + idx_x * 1 + idx_y * 1 * xdim2_accelerate_kernel],
                       &arg3[base3 + idx_x * 1 + idx_y * 1 * xdim3_accelerate_kernel],
                       &arg4[base4 + idx_x * 1 + idx_y * 1 * xdim4_accelerate_kernel],
                       &arg5[base5 + idx_x * 1 + idx_y * 1 * xdim5_accelerate_kernel],
                       &arg6[base6 + idx_x * 1 + idx_y * 1 * xdim6_accelerate_kernel],
                       &arg7[base7 + idx_x * 1 + idx_y * 1 * xdim7_accelerate_kernel],
                       &arg8[base8 + idx_x * 1 + idx_y * 1 * xdim8_accelerate_kernel],
                       &arg9[base9 + idx_x * 1 + idx_y * 1 * xdim9_accelerate_kernel],
                       &arg10[base10 + idx_x * 1 + idx_y * 1 * xdim10_accelerate_kernel],
                       dt);
   }

 }
