//
// auto-generated by ops.py on 2014-08-08 13:40
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
#define OPS_ACC0(x,y,z) (x+xdim0_calc_dt_kernel*(y)+xdim0_calc_dt_kernel*ydim0_calc_dt_kernel*(z))
#define OPS_ACC1(x,y,z) (x+xdim1_calc_dt_kernel*(y)+xdim1_calc_dt_kernel*ydim1_calc_dt_kernel*(z))
#define OPS_ACC2(x,y,z) (x+xdim2_calc_dt_kernel*(y)+xdim2_calc_dt_kernel*ydim2_calc_dt_kernel*(z))
#define OPS_ACC3(x,y,z) (x+xdim3_calc_dt_kernel*(y)+xdim3_calc_dt_kernel*ydim3_calc_dt_kernel*(z))
#define OPS_ACC4(x,y,z) (x+xdim4_calc_dt_kernel*(y)+xdim4_calc_dt_kernel*ydim4_calc_dt_kernel*(z))
#define OPS_ACC5(x,y,z) (x+xdim5_calc_dt_kernel*(y)+xdim5_calc_dt_kernel*ydim5_calc_dt_kernel*(z))
#define OPS_ACC6(x,y,z) (x+xdim6_calc_dt_kernel*(y)+xdim6_calc_dt_kernel*ydim6_calc_dt_kernel*(z))
#define OPS_ACC7(x,y,z) (x+xdim7_calc_dt_kernel*(y)+xdim7_calc_dt_kernel*ydim7_calc_dt_kernel*(z))
#define OPS_ACC8(x,y,z) (x+xdim8_calc_dt_kernel*(y)+xdim8_calc_dt_kernel*ydim8_calc_dt_kernel*(z))
#define OPS_ACC9(x,y,z) (x+xdim9_calc_dt_kernel*(y)+xdim9_calc_dt_kernel*ydim9_calc_dt_kernel*(z))
#define OPS_ACC10(x,y,z) (x+xdim10_calc_dt_kernel*(y)+xdim10_calc_dt_kernel*ydim10_calc_dt_kernel*(z))
#define OPS_ACC11(x,y,z) (x+xdim11_calc_dt_kernel*(y)+xdim11_calc_dt_kernel*ydim11_calc_dt_kernel*(z))
#define OPS_ACC12(x,y,z) (x+xdim12_calc_dt_kernel*(y)+xdim12_calc_dt_kernel*ydim12_calc_dt_kernel*(z))
#define OPS_ACC13(x,y,z) (x+xdim13_calc_dt_kernel*(y)+xdim13_calc_dt_kernel*ydim13_calc_dt_kernel*(z))


//user function
void calc_dt_kernel(const __global double * restrict celldx, const __global double * restrict celldy, const __global double * restrict soundspeed, 
const __global double * restrict viscosity, const __global double * restrict density0, const __global double * restrict xvel0, const __global double * restrict xarea, 
const __global double * restrict volume, const __global double * restrict yvel0, const __global double * restrict yarea, __global double * restrict dt_min, 
const __global double * restrict celldz, const __global double * restrict zvel0, const __global double * restrict zarea, 
  const double g_small,
const double dtc_safe,
const double dtu_safe,
const double dtv_safe,
const double dtw_safe,
const double dtdiv_safe)

  {

  double div, ds, dtut, dtvt, dtct, dtwt, dtdivt, cc, dv1, dv2, du1, du2, dw1, dw2;

  ds = MIN(MIN(celldx[OPS_ACC0(0,0,0)], celldy[OPS_ACC1(0,0,0)]), celldz[OPS_ACC11(0,0,0)]);
  ds = 1.0/(ds*ds);

  cc = soundspeed[OPS_ACC2(0,0,0)] * soundspeed[OPS_ACC2(0,0,0)];
  cc = cc + 2.0 * viscosity[OPS_ACC3(0,0,0)]/density0[OPS_ACC4(0,0,0)];

  dtct=ds*cc;
  dtct = dtc_safe*1.0/MAX(sqrt(dtct),g_small);

  du1=(xvel0[OPS_ACC5(0,0,0)]+xvel0[OPS_ACC5(0,1,0)]+xvel0[OPS_ACC5(0,0,1)]+xvel0[OPS_ACC5(0,1,1)])*xarea[OPS_ACC6(0,0,0)];
  du2=(xvel0[OPS_ACC5(1,0,0)]+xvel0[OPS_ACC5(1,1,0)]+xvel0[OPS_ACC5(1,0,1)]+xvel0[OPS_ACC5(1,1,1)])*xarea[OPS_ACC6(0,0,0)];

  dtut = dtu_safe * 4.0 * volume[OPS_ACC7(0,0,0)]/MAX(MAX(fabs(du1), fabs(du2)), 1.0e-5 * volume[OPS_ACC7(0,0,0)]);

  dv1=(yvel0[OPS_ACC8(0,0,0)]+yvel0[OPS_ACC8(1,0,0)]+yvel0[OPS_ACC8(0,0,1)]+yvel0[OPS_ACC8(1,0,1)])*yarea[OPS_ACC9(0,0,0)];
  dv2=(yvel0[OPS_ACC8(0,1,0)]+yvel0[OPS_ACC8(1,1,0)]+yvel0[OPS_ACC8(0,1,1)]+yvel0[OPS_ACC8(1,1,1)])*yarea[OPS_ACC9(0,0,0)];

  dtvt = dtv_safe * 4.0 * volume[OPS_ACC7(0,0,0)]/MAX(MAX(fabs(dv1),fabs(dv2)), 1.0e-5 * volume[OPS_ACC7(0,0,0)]);

  dw1=(zvel0[OPS_ACC12(0,0,0)]+zvel0[OPS_ACC12(0,1,0)]+zvel0[OPS_ACC12(1,0,0)]+zvel0[OPS_ACC12(1,1,0)])*zarea[OPS_ACC13(0,0,0)];
  dw2=(zvel0[OPS_ACC12(0,0,1)]+zvel0[OPS_ACC12(0,1,1)]+zvel0[OPS_ACC12(1,0,1)]+zvel0[OPS_ACC12(1,1,1)])*zarea[OPS_ACC13(0,0,0)];

  dtwt = dtw_safe * 4.0 * volume[OPS_ACC7(0,0,0)]/MAX(MAX(fabs(dw1),fabs(dw2)), 1.0e-5 * volume[OPS_ACC7(0,0,0)]);

  div = du2-du1+dv2-dv1+dw2-dw1;
  dtdivt=dtdiv_safe*4.0*(volume[OPS_ACC7(0,0,0)])/MAX(volume[OPS_ACC7(0,0,0)]*1.0e-05,fabs(div));

  dt_min[OPS_ACC10(0,0,0)] = MIN(MIN(MIN(dtct, dtut), MIN(dtvt, dtdivt)),dtwt);
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
 #undef OPS_ACC11
 #undef OPS_ACC12
 #undef OPS_ACC13


 __kernel void ops_calc_dt_kernel(
 __global const double* restrict arg0,
 __global const double* restrict arg1,
 __global const double* restrict arg2,
 __global const double* restrict arg3,
 __global const double* restrict arg4,
 __global const double* restrict arg5,
 __global const double* restrict arg6,
 __global const double* restrict arg7,
 __global const double* restrict arg8,
 __global const double* restrict arg9,
 __global double* restrict arg10,
 __global const double* restrict arg11,
 __global const double* restrict arg12,
 __global const double* restrict arg13,
 const double g_small,
 const double dtc_safe,
 const double dtu_safe,
 const double dtv_safe,
 const double dtw_safe,
 const double dtdiv_safe,
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
 const int base11,
 const int base12,
 const int base13,
 const int size0,
 const int size1,
 const int size2 ){


   int idx_z = get_global_id(2);
   int idx_y = get_global_id(1);
   int idx_x = get_global_id(0);

   if (idx_x < size0 && idx_y < size1 && idx_z < size2) {
     calc_dt_kernel(&arg0[base0 + idx_x * 1 + idx_y * 0 * xdim0_calc_dt_kernel + idx_z * 0 * xdim0_calc_dt_kernel * ydim0_calc_dt_kernel],
                    &arg1[base1 + idx_x * 0 + idx_y * 1 * xdim1_calc_dt_kernel + idx_z * 0 * xdim1_calc_dt_kernel * ydim1_calc_dt_kernel],
                    &arg2[base2 + idx_x * 1 + idx_y * 1 * xdim2_calc_dt_kernel + idx_z * 1 * xdim2_calc_dt_kernel * ydim2_calc_dt_kernel],
                    &arg3[base3 + idx_x * 1 + idx_y * 1 * xdim3_calc_dt_kernel + idx_z * 1 * xdim3_calc_dt_kernel * ydim3_calc_dt_kernel],
                    &arg4[base4 + idx_x * 1 + idx_y * 1 * xdim4_calc_dt_kernel + idx_z * 1 * xdim4_calc_dt_kernel * ydim4_calc_dt_kernel],
                    &arg5[base5 + idx_x * 1 + idx_y * 1 * xdim5_calc_dt_kernel + idx_z * 1 * xdim5_calc_dt_kernel * ydim5_calc_dt_kernel],
                    &arg6[base6 + idx_x * 1 + idx_y * 1 * xdim6_calc_dt_kernel + idx_z * 1 * xdim6_calc_dt_kernel * ydim6_calc_dt_kernel],
                    &arg7[base7 + idx_x * 1 + idx_y * 1 * xdim7_calc_dt_kernel + idx_z * 1 * xdim7_calc_dt_kernel * ydim7_calc_dt_kernel],
                    &arg8[base8 + idx_x * 1 + idx_y * 1 * xdim8_calc_dt_kernel + idx_z * 1 * xdim8_calc_dt_kernel * ydim8_calc_dt_kernel],
                    &arg9[base9 + idx_x * 1 + idx_y * 1 * xdim9_calc_dt_kernel + idx_z * 1 * xdim9_calc_dt_kernel * ydim9_calc_dt_kernel],
                    &arg10[base10 + idx_x * 1 + idx_y * 1 * xdim10_calc_dt_kernel + idx_z * 1 * xdim10_calc_dt_kernel * ydim10_calc_dt_kernel],
                    &arg11[base11 + idx_x * 0 + idx_y * 0 * xdim11_calc_dt_kernel + idx_z * 1 * xdim11_calc_dt_kernel * ydim11_calc_dt_kernel],
                    &arg12[base12 + idx_x * 1 + idx_y * 1 * xdim12_calc_dt_kernel + idx_z * 1 * xdim12_calc_dt_kernel * ydim12_calc_dt_kernel],
                    &arg13[base13 + idx_x * 1 + idx_y * 1 * xdim13_calc_dt_kernel + idx_z * 1 * xdim13_calc_dt_kernel * ydim13_calc_dt_kernel],
                    g_small,
                    dtc_safe,
                    dtu_safe,
                    dtv_safe,
                    dtw_safe,
                    dtdiv_safe);
   }

 }
