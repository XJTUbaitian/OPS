//
// auto-generated by ops.py on 2014-05-28 15:13
//

#include "user_types.h"

#ifndef MIN
#define MIN(a,b) ((a<b) ? (a) : (b))
#endif
#ifndef MAX
#define MAX(a,b) ((a>b) ? (a) : (b))
#endif
#ifndef SIGN
#define SIGN(a,b) ((b<0.0) ? (a*(-1)) : (a))
#endif

#pragma OPENCL EXTENSION cl_khr_fp64:enable

#define OPS_ACC0(x,y) (x+xdim0_ideal_gas_kernel*(y))
#define OPS_ACC1(x,y) (x+xdim1_ideal_gas_kernel*(y))
#define OPS_ACC2(x,y) (x+xdim2_ideal_gas_kernel*(y))
#define OPS_ACC3(x,y) (x+xdim3_ideal_gas_kernel*(y))


//user function

void ideal_gas_kernel(  __global double *density,  __global double *energy,
                     __global double *pressure, __global double *soundspeed,
  int xdim0_ideal_gas_kernel,
int xdim1_ideal_gas_kernel,
int xdim2_ideal_gas_kernel,
int xdim3_ideal_gas_kernel)

  {

  double sound_speed_squared, v, pressurebyenergy, pressurebyvolume;

  v = 1.0 / density[OPS_ACC0(0,0)];
  pressure[OPS_ACC2(0,0)] = (1.4 - 1.0) * density[OPS_ACC0(0,0)] * energy[OPS_ACC1(0,0)];
  pressurebyenergy = (1.4 - 1.0) * density[OPS_ACC0(0,0)];
  pressurebyvolume = -1*density[OPS_ACC0(0,0)] * pressure[OPS_ACC2(0,0)];
  sound_speed_squared = v*v*(pressure[OPS_ACC2(0,0)] * pressurebyenergy-pressurebyvolume);
  soundspeed[OPS_ACC3(0,0)] = sqrt(sound_speed_squared);
}



 #undef OPS_ACC0
 #undef OPS_ACC1
 #undef OPS_ACC2
 #undef OPS_ACC3


 __kernel void ops_ideal_gas_kernel(
 __global double* arg0,
 __global double* arg1,
 __global double* arg2,
 __global double* arg3,
 int xdim0_ideal_gas_kernel,
 int xdim1_ideal_gas_kernel,
 int xdim2_ideal_gas_kernel,
 int xdim3_ideal_gas_kernel,
 const int base0,
 const int base1,
 const int base2,
 const int base3,
 int size0,
 int size1 ){


   int idx_y = get_global_id(1);
   int idx_x = get_global_id(0);

   if (idx_x < size0 && idx_y < size1) {
     ideal_gas_kernel(&arg0[base0 + idx_x * 1 + idx_y * 1 * xdim0_ideal_gas_kernel],
                      &arg1[base1 + idx_x * 1 + idx_y * 1 * xdim1_ideal_gas_kernel],
                      &arg2[base2 + idx_x * 1 + idx_y * 1 * xdim2_ideal_gas_kernel],
                      &arg3[base3 + idx_x * 1 + idx_y * 1 * xdim3_ideal_gas_kernel],
                      
                      xdim0_ideal_gas_kernel,
                      xdim1_ideal_gas_kernel,
                      xdim2_ideal_gas_kernel,
                      xdim3_ideal_gas_kernel);
   }

 }
