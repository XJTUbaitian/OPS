//
// auto-generated by ops.py on 2014-08-08 12:31
//

#include "./OpenACC/clover_leaf_common.h"

#define OPS_GPU

int xdim0_advec_cell_kernel1_xdir;
int xdim1_advec_cell_kernel1_xdir;
int xdim2_advec_cell_kernel1_xdir;
int xdim3_advec_cell_kernel1_xdir;
int xdim4_advec_cell_kernel1_xdir;

#define OPS_ACC0(x,y) (x+xdim0_advec_cell_kernel1_xdir*(y))
#define OPS_ACC1(x,y) (x+xdim1_advec_cell_kernel1_xdir*(y))
#define OPS_ACC2(x,y) (x+xdim2_advec_cell_kernel1_xdir*(y))
#define OPS_ACC3(x,y) (x+xdim3_advec_cell_kernel1_xdir*(y))
#define OPS_ACC4(x,y) (x+xdim4_advec_cell_kernel1_xdir*(y))

//user function

inline void advec_cell_kernel1_xdir( double *pre_vol, double *post_vol, const double *volume,
                        const double *vol_flux_x, const double *vol_flux_y) {

  pre_vol[OPS_ACC0(0,0)] = volume[OPS_ACC2(0,0)] + ( vol_flux_x[OPS_ACC3(1,0)] - vol_flux_x[OPS_ACC3(0,0)] +
                           vol_flux_y[OPS_ACC4(0,1)] - vol_flux_y[OPS_ACC4(0,0)]);
  post_vol[OPS_ACC1(0,0)] = pre_vol[OPS_ACC0(0,0)] - ( vol_flux_x[OPS_ACC3(1,0)] - vol_flux_x[OPS_ACC3(0,0)]);

}



#undef OPS_ACC0
#undef OPS_ACC1
#undef OPS_ACC2
#undef OPS_ACC3
#undef OPS_ACC4


void advec_cell_kernel1_xdir_c_wrapper(
  double *p_a0,
  double *p_a1,
  double *p_a2,
  double *p_a3,
  double *p_a4,
  int x_size, int y_size) {
  #ifdef OPS_GPU
  #pragma acc parallel deviceptr(p_a0,p_a1,p_a2,p_a3,p_a4)
  #pragma acc loop
  #endif
  for ( int n_y=0; n_y<y_size; n_y++ ){
    #ifdef OPS_GPU
    #pragma acc loop
    #endif
    for ( int n_x=0; n_x<x_size; n_x++ ){
      advec_cell_kernel1_xdir(  p_a0 + n_x*1 + n_y*xdim0_advec_cell_kernel1_xdir*1,
           p_a1 + n_x*1 + n_y*xdim1_advec_cell_kernel1_xdir*1, p_a2 + n_x*1 + n_y*xdim2_advec_cell_kernel1_xdir*1,
           p_a3 + n_x*1 + n_y*xdim3_advec_cell_kernel1_xdir*1, p_a4 + n_x*1 + n_y*xdim4_advec_cell_kernel1_xdir*1 );

    }
  }
}
