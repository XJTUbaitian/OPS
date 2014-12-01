//
// auto-generated by ops.py
//
#include "./OpenACC/clover_leaf_common.h"

#define OPS_GPU

int xdim0_advec_mom_kernel_mass_flux_x;
int xdim1_advec_mom_kernel_mass_flux_x;

#define OPS_ACC0(x,y) (x+xdim0_advec_mom_kernel_mass_flux_x*(y))
#define OPS_ACC1(x,y) (x+xdim1_advec_mom_kernel_mass_flux_x*(y))

//user function

inline void advec_mom_kernel_mass_flux_x( double *node_flux, const double *mass_flux_x) {


  node_flux[OPS_ACC0(0,0)] = 0.25 * ( mass_flux_x[OPS_ACC1(0,-1)] + mass_flux_x[OPS_ACC1(0,0)] +
    mass_flux_x[OPS_ACC1(1,-1)] + mass_flux_x[OPS_ACC1(1,0)] );
}


#undef OPS_ACC0
#undef OPS_ACC1



void advec_mom_kernel_mass_flux_x_c_wrapper(
  double *p_a0,
  double *p_a1,
  int x_size, int y_size) {
  #ifdef OPS_GPU
  #pragma acc parallel deviceptr(p_a0,p_a1)
  #pragma acc loop
  #endif
  for ( int n_y=0; n_y<y_size; n_y++ ){
    #ifdef OPS_GPU
    #pragma acc loop
    #endif
    for ( int n_x=0; n_x<x_size; n_x++ ){
      advec_mom_kernel_mass_flux_x(  p_a0 + n_x*1*1 + n_y*xdim0_advec_mom_kernel_mass_flux_x*1*1,
           p_a1 + n_x*1*1 + n_y*xdim1_advec_mom_kernel_mass_flux_x*1*1 );

    }
  }
}
