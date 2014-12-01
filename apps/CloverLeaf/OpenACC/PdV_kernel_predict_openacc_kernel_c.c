//
// auto-generated by ops.py
//
#include "./OpenACC/clover_leaf_common.h"

#define OPS_GPU

int xdim0_PdV_kernel_predict;
int xdim1_PdV_kernel_predict;
int xdim2_PdV_kernel_predict;
int xdim3_PdV_kernel_predict;
int xdim4_PdV_kernel_predict;
int xdim5_PdV_kernel_predict;
int xdim6_PdV_kernel_predict;
int xdim7_PdV_kernel_predict;
int xdim8_PdV_kernel_predict;
int xdim9_PdV_kernel_predict;
int xdim10_PdV_kernel_predict;
int xdim11_PdV_kernel_predict;

#define OPS_ACC0(x,y) (x+xdim0_PdV_kernel_predict*(y))
#define OPS_ACC1(x,y) (x+xdim1_PdV_kernel_predict*(y))
#define OPS_ACC2(x,y) (x+xdim2_PdV_kernel_predict*(y))
#define OPS_ACC3(x,y) (x+xdim3_PdV_kernel_predict*(y))
#define OPS_ACC4(x,y) (x+xdim4_PdV_kernel_predict*(y))
#define OPS_ACC5(x,y) (x+xdim5_PdV_kernel_predict*(y))
#define OPS_ACC6(x,y) (x+xdim6_PdV_kernel_predict*(y))
#define OPS_ACC7(x,y) (x+xdim7_PdV_kernel_predict*(y))
#define OPS_ACC8(x,y) (x+xdim8_PdV_kernel_predict*(y))
#define OPS_ACC9(x,y) (x+xdim9_PdV_kernel_predict*(y))
#define OPS_ACC10(x,y) (x+xdim10_PdV_kernel_predict*(y))
#define OPS_ACC11(x,y) (x+xdim11_PdV_kernel_predict*(y))

//user function
inline 
void PdV_kernel_predict(const double *xarea, const double *xvel0,
                const double *yarea, const double *yvel0,
                double *volume_change, const double *volume,
                const double *pressure,
                const double *density0, double *density1,
                const double *viscosity,
                const double *energy0, double *energy1) {


  double recip_volume, energy_change, min_cell_volume;
  double right_flux, left_flux, top_flux, bottom_flux, total_flux;

  left_flux = ( xarea[OPS_ACC0(0,0)] * ( xvel0[OPS_ACC1(0,0)] + xvel0[OPS_ACC1(0,1)] +
                                xvel0[OPS_ACC1(0,0)] + xvel0[OPS_ACC1(0,1)] ) ) * 0.25 * dt * 0.5;
  right_flux = ( xarea[OPS_ACC0(1,0)] * ( xvel0[OPS_ACC1(1,0)] + xvel0[OPS_ACC1(1,1)] +
                                 xvel0[OPS_ACC1(1,0)] + xvel0[OPS_ACC1(1,1)] ) ) * 0.25 * dt * 0.5;

  bottom_flux = ( yarea[OPS_ACC2(0,0)] * ( yvel0[OPS_ACC3(0,0)] + yvel0[OPS_ACC3(1,0)] +
                                  yvel0[OPS_ACC3(0,0)] + yvel0[OPS_ACC3(1,0)] ) ) * 0.25* dt * 0.5;
  top_flux = ( yarea[OPS_ACC2(0,1)] * ( yvel0[OPS_ACC3(0,1)] + yvel0[OPS_ACC3(1,1)] +
                               yvel0[OPS_ACC3(0,1)] + yvel0[OPS_ACC3(1,1)] ) ) * 0.25 * dt * 0.5;

  total_flux = right_flux - left_flux + top_flux - bottom_flux;

  volume_change[OPS_ACC4(0,0)] = (volume[OPS_ACC5(0,0)])/(volume[OPS_ACC5(0,0)] + total_flux);

  min_cell_volume = MIN( volume[OPS_ACC5(0,0)] + right_flux - left_flux + top_flux - bottom_flux ,
                           MIN(volume[OPS_ACC5(0,0)] + right_flux - left_flux,
                           volume[OPS_ACC5(0,0)] + top_flux - bottom_flux) );

  recip_volume = 1.0/volume[OPS_ACC5(0,0)];

  energy_change = ( pressure[OPS_ACC6(0,0)]/density0[OPS_ACC7(0,0)] +
                    viscosity[OPS_ACC9(0,0)]/density0[OPS_ACC7(0,0)] ) * total_flux * recip_volume;
  energy1[OPS_ACC11(0,0)] = energy0[OPS_ACC10(0,0)] - energy_change;
  density1[OPS_ACC8(0,0)] = density0[OPS_ACC7(0,0)] * volume_change[OPS_ACC4(0,0)];

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



void PdV_kernel_predict_c_wrapper(
  double *p_a0,
  double *p_a1,
  double *p_a2,
  double *p_a3,
  double *p_a4,
  double *p_a5,
  double *p_a6,
  double *p_a7,
  double *p_a8,
  double *p_a9,
  double *p_a10,
  double *p_a11,
  int x_size, int y_size) {
  #ifdef OPS_GPU
  #pragma acc parallel deviceptr(p_a0,p_a1,p_a2,p_a3,p_a4,p_a5,p_a6,p_a7,p_a8,p_a9,p_a10,p_a11)
  #pragma acc loop
  #endif
  for ( int n_y=0; n_y<y_size; n_y++ ){
    #ifdef OPS_GPU
    #pragma acc loop
    #endif
    for ( int n_x=0; n_x<x_size; n_x++ ){
      PdV_kernel_predict(  p_a0 + n_x*1*1 + n_y*xdim0_PdV_kernel_predict*1*1,
           p_a1 + n_x*1*1 + n_y*xdim1_PdV_kernel_predict*1*1, p_a2 + n_x*1*1 + n_y*xdim2_PdV_kernel_predict*1*1,
           p_a3 + n_x*1*1 + n_y*xdim3_PdV_kernel_predict*1*1, p_a4 + n_x*1*1 + n_y*xdim4_PdV_kernel_predict*1*1,
           p_a5 + n_x*1*1 + n_y*xdim5_PdV_kernel_predict*1*1, p_a6 + n_x*1*1 + n_y*xdim6_PdV_kernel_predict*1*1,
           p_a7 + n_x*1*1 + n_y*xdim7_PdV_kernel_predict*1*1, p_a8 + n_x*1*1 + n_y*xdim8_PdV_kernel_predict*1*1,
           p_a9 + n_x*1*1 + n_y*xdim9_PdV_kernel_predict*1*1, p_a10 + n_x*1*1 + n_y*xdim10_PdV_kernel_predict*1*1,
           p_a11 + n_x*1*1 + n_y*xdim11_PdV_kernel_predict*1*1 );

    }
  }
}
